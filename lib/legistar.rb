module Legistar

	module_function

	# hack. This should go in a config file. TODO.
	def city
		'Mesa'
	end

	# set up logging and Legistar base settings
  def initialize
  	@@log = Logger.new(STDOUT)
    @@fileLog = Logger.new("log/fetch-legistar.log")
    @@log.level = Logger::DEBUG
    @@fileLog.level = Logger::DEBUG
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
	end

  # given the URL of one of the Legistar documentation pages,
  # return the documented structure of the endpoint in a format
  # that is compatible with the Rails model creation migrations.
  def fetch_structure(url, endpoint_prefix_to_strip)
    log = Logger.new('log/faraday.log')
    connection = Faraday.new(:url => "https://api.import.io") do |conn|
      conn.request  :url_encoded             # form-encode POST params
      # conn.response :logger                  # log requests to STDOUT
      conn.use Faraday::Response::Logger, log
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    which_api = '4c1ec1ba-762d-421d-9da0-a399be0919d0'
    query_params = { _apikey: 'c/XK9NG0FdIXYH7VxUSqWPhXa9oJZN0NLuuGic7duphtqaesQJHzL/V4Z73vuSpIaPGa8z4it1O+jwoFxT2scQ==',
                     _user: 'c4296b63-fe04-499c-b437-11f00cb2a721' }.to_query
    query_url = "/store/data/#{which_api}/_query?#{query_params}"

    begin
      # post payload as JSON
      body = '{ "input": { "webpage/url": "' + url + '"}}'
      response = connection.post do |req|
        req.url query_url
        req.headers['Content-Type'] = 'application/json'
        req.body = body
      end
      raise unless response.status == 200
      log.info response.body
      structure = ActiveSupport::JSON.decode(response.body)
      structure_string = PP.pp structure, dump = ""
      log.info(structure_string)
      print_migration(structure, endpoint_prefix_to_strip)
    rescue Faraday::Error::ConnectionFailed => e
      log_error "Connection failed for #{url}: #{e}"
    rescue => e
      msg = "Failed fetching for query_url: #{url}, body: #{body}; status: #{response.status}, error: #{e}"
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

      response = @@connection.get(@@url_path)
      raise unless response.status == 200

      to_objects(response.body)
      sleep @@wait

    rescue Faraday::Error::ConnectionFailed => e
      log_error "Connection failed for #{full_url}: #{e}"
    rescue => e
      msg = "Failed fetching #{full_url}, error: #{e}"
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

		  pretty_attributes = pp attrs
		  msg = "Attempting creation of #{@@endpoint_class.to_s} with attrs: #{pretty_attributes}"
		  log_info(msg)

		  @@endpoint_class.create(attrs)
		end
	end

	def self.log_info(msg)
		@@log.info(msg)
		@@fileLog.info(msg)
	end

  def self.log_error(msg)
    @@log.error(msg)
    @@fileLog.error(msg)
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
