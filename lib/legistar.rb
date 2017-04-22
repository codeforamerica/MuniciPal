require 'pp'

module Legistar

  @log = Logger.new(STDOUT)
  # @log.level = Logger::INFO
  @log.level = Logger::WARN

  class LegistarHTTPmismatch < StandardError
  end

	module_function

  def http_response_mismatch(http_method, expected, got)
    # try to give the user somewhat human friendly responses
    # (NET::HTTPOK is as close as we can easily get to 'HTTP OK')
    msg = "#{http_method} expected status #{expected}"\
          " (#{Net::HTTPResponse::CODE_TO_OBJ[expected.to_s]}),"\
          " but got #{got}"\
          " (#{Net::HTTPResponse::CODE_TO_OBJ[got.to_s]})"
    LegistarHTTPmismatch.new(msg)
  end

	# hack. This should go in a config file. TODO.
	def city
		'Mesa'
	end

	# set up logging and Legistar base settings
  def initialize
    logfile = "log/fetch-legistar.log"
    @file_log = Logger.new(logfile)
    @log.level = Logger::DEBUG
    @file_log.level = Logger::DEBUG
    @@base_url = 'http://webapi.legistar.com'
    # extras: any additional parameters that should be set on each object (optional)
    @@extras = nil
    @@wait = 0.5 #seconds to wait between fetching

		@@connection = Faraday.new(url: @@base_url) do |conn|
			conn.headers['Accept'] = 'text/json'
			conn.request :instrumentation
			conn.response :json
      conn.adapter Faraday.default_adapter
      conn.request :retry, max: 5, interval: 0.05, interval: 0.05, interval_randomness: 0.5, backoff_factor: 2
	  end

    @log.info("Connection opened to #{@@base_url} and logging to #{logfile}")
	end

  # given the URL of one of the Legistar documentation pages,
  # return the documented structure of the endpoint in a format
  # that is compatible with the Rails model creation migrations.
  #
  # Example for getting the structure of the Event endpoint:
  # rake legistar_all:structure[http://webapi.legistar.com/Help/Api/GET-v1-Client-Events]
  # but the output will be like
  # t.integer :event_id
  # t.string :event_guid
  # ...
  # so you might want to strip off 'event':
  # rake legistar_all:structure[http://webapi.legistar.com/Help/Api/GET-v1-Client-Events,"Event"]:
  # t.integer :id
  # t.string :guid
  # ...
  # Note! Make sure not to have a space between the arguments to the rake task.
  def fetch_structure(url, endpoint_prefix_to_strip)
    endpoint_prefix_to_strip = endpoint_prefix_to_strip || ""
    base_url = "https://api.import.io"
    logfile = "log/fetch-structure.log"

    @file_log = Logger.new(logfile)
    @file_log.level = Logger::WARN # Or use ::INFO or ::DEBUG for more info

    connection = Faraday.new(:url => base_url) do |conn|
      conn.request  :url_encoded             # form-encode POST params
      conn.response :logger, @log # log requests to STDOUT
      conn.use Faraday::Response::Logger, @file_log
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    @log.info("Connection opened to #{base_url} and logging to #{logfile}")

    which_api = '4c1ec1ba-762d-421d-9da0-a399be0919d0'
    query_params = {
      input: "webpage/url:#{url}",
      _apikey: "c4296b63fe04499cb43711f00cb2a72173f5caf4d1b415d217607ed5c544"\
               "aa58f8576bda0964dd0d2eeb8689ceddba986da9a7ac4091f32ff57867bd"\
               "efb92a4868f19af33e22b753be8f0a05c53dac71",
    }.to_query
    query_url = "/store/connector/#{which_api}/_query?#{query_params}"

    begin
      response = connection.get do |req|
        req.url query_url
        req.headers['Content-Type'] = 'application/json'
      end
      if response.status != 200 # Net::HTTPOK
        raise http_response_mismatch("GET", 200, response.status)
      end

      @log.info response.body
      structure = ActiveSupport::JSON.decode(response.body)
      structure_string = PP.pp structure, dump = ""
      @log.info(structure_string)
      print_migration(structure, endpoint_prefix_to_strip)

    rescue Faraday::Error::ConnectionFailed => e
      log_error "Connection failed for #{url}: #{e}"
    rescue ActiveSupport::JSON.parse_error
      log_error "Attempted to decode invalid JSON: #{response.body}"
    rescue Legistar::LegistarHTTPmismatch => e
      msg = "Failed fetching #{base_url}#{query_url}. #{e}"
      log_error(msg)
    rescue => e
      msg = "Unexpected error caught by line #{__LINE__}: #{e}, "\
            "Trace:\n#{e.backtrace.join "\n"}"
      log_error(msg)
    end
  end

	# fetches items from an endpoint nested within a nesting_endpoint.
	# example from Legistar API:
		# /v1/{client}/Events/{id}/EventItems
		# endpoint is 'EventItems'
		# endpoint_filter is nil
		# endpoint_prefix_to_strip is 'EventItem'
		# endpoint_class is EventItem
		# nesting_endpoint is 'Events'
		# nesting_class is Event
  # By default, the endpoints within every item of nesting class will be fetched;
  # the set can be overridden by passing in nesting_collection though.
	def fetch_nested_collection(endpoint,
															endpoint_filter,
															endpoint_prefix_to_strip,
															endpoint_class,
															nesting_endpoint,
															nesting_class,
                              nesting_collection=nil)

    @@endpoint = endpoint # 'EventItems'
    @@prefix_to_strip = endpoint_prefix_to_strip #'EventItem'
		@@endpoint_class = endpoint_class #EventItem

    log_info("fetching from endpoint: #{endpoint} (nesting_endpoint: #{nesting_endpoint}), filter: #{endpoint_filter}, prefix: #{endpoint_prefix_to_strip}, class: #{endpoint_class}")

    nesting_collection ||= nesting_class.all
    nesting_collection.each do |nesting_item|
    	# url = "/Events/#{event.source_id}/EventItems"
		  @@url_path = "/v1/#{Legistar.city}/#{nesting_endpoint}/#{nesting_item.source_id}/#{endpoint}#{endpoint_filter}"

      # for nested items (like Attachments or EventItems),
      # we want to keep a reference to the nesting object's id.
      # note that this is more important for Attachments, which don't
      # have an MatterId field, while EventItems do have an EventId.
      @@extras = { nesting_class.to_s.underscore + '_id' => nesting_item.source_id}

      go_fetch()
    end
  end



	# endpoint: which endpoint in the Legistar API to fetch
	#          example: 'events' for fetching from /v1/#{Legistar.city}/events
	# endpoint_class: the Class of structure to create with the data retrieved from API
	#          example: Event
	def fetch_collection(endpoint,
                       filter,
                       prefix_to_strip,
                       endpoint_class)
		@@endpoint = endpoint
    @@prefix_to_strip = prefix_to_strip
		@@endpoint_class = endpoint_class
    @@url_path = "/v1/#{Legistar.city}/#{endpoint}#{filter}"

    log_info("fetching from endpoint: #{endpoint}, filter: #{filter}, prefix: #{prefix_to_strip}, class: #{endpoint_class}")
    go_fetch()
	end

	protected

  def self.go_fetch
    begin

      full_url = @@base_url + @@url_path
      log_info("url: #{full_url}")
      print "."

      response = @@connection.get(@@url_path)
      raise unless response.status == 200

      to_objects(response.body)
      sleep @@wait

    rescue Faraday::Error::ConnectionFailed => e
      log_error "Connection failed for #{full_url}: #{e}"
    rescue => e
      msg = "Failed fetching #{full_url}, error: #{e}, near #{__FILE__}:#{__LINE__}"
      if response
        msg << ", status: #{response.status}"
      end
      log_error(msg)
    end
  end

	# collection: array of items returned from a Legistar collection endpoint
  def self.to_objects(collection)
    collection.each do |item|
      attrs = rubify_object(item, @@prefix_to_strip)
      attrs['source_id'] = attrs.delete('id')
      @@extras.each { |k,v| attrs[k] = v } if @@extras

      if @@endpoint_class == Event
        # strip EventItems from Event before creating
        attrs.delete('items')
      end

      if @@endpoint_class == EventItem
        # strip MatterAttachements from EventItems before creating
        attrs.delete('matter_attachments') # TODO? link Attachment -> EventItem?
      end

      pretty_attributes = PP.pp attrs, dump = ""
      msg = "Attempting creation of #{@@endpoint_class.to_s} "\
            "with attrs: #{pretty_attributes}"
      log_info(msg)

      @@endpoint_class.find_or_create_by(attrs)
    end
  end

	def self.log_info(msg)
    @log.info(msg) unless Rails.env.production?
    @file_log.info(msg)
	end

  def self.log_error(msg)
    @log.error(msg)
    @file_log.error(msg)
  end

  # Take the structure described in the Legistar API and
  # output it in a format useful for a migration file.
  def self.print_migration(structure, prefix_to_strip)
    # structure.results is an array of objects with 'name' and
    # 'type' fields. Note that the name will be in PascalCase,
    # not snake_case. It will also have the RestEndpointName
    # prepended to each.
    # We need to convert that into lines like: t.integer :source_id
    structure['results'].each do |field|
      puts 't.' + rubify_type(field['type']) + ' :' + rubify_name(field['name'], prefix_to_strip)
    end
  end

  # convert types from Legistar documentation to ruby appropriate types
  def self.rubify_type(type)
    case type
    when 'Collection of byte' then 'string'
    when 'date' then 'datetime'
    else type
    end
  end

  # Takes objects with camel case property names and converts
  # to ruby format.
  # camelcase_object: just SomeObject object which needs to have
  #       SomeObjectPropertyNames changed to property_names
  # prefix_to_strip: any CamelCase part like 'SomeObject' which should be
  #        removed before converting the rest of the name to snake_case
  # Example:
  # camel = { 'CamelFirstName' => 'Ed', 'CamelLastName' => 'Jones' }
  # rubify_object(camel, 'Camel')
  # => {"first_name"=>"Ed", "last_name"=>"Jones"}
  #
  def self.rubify_object(camelcase_object, prefix_to_strip)
    attrs = camelcase_object.reduce({}){ |result, (k,v)|
              result[rubify_name(k, prefix_to_strip)] = v
              result
            }
  end

  # Convert prefixed PascalCase to snake_case, sans prefix
  # ex: rubyify_name('PrefixedFieldName', 'Prefixed') => 'field_name'
  def self.rubify_name(camelcase_name, prefix_to_strip)
    camelcase_name.sub(prefix_to_strip, '').underscore
  end


end
