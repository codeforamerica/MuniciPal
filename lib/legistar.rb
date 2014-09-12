require 'net/http'
require 'json'
require 'logger'
require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'prettyprint'

module Legistar

	module_function

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
	def rubify_object(camelcase_object, prefix_to_strip)
	  attrs = camelcase_object.reduce({}){ |result, (k,v)|
	            result[rubify_name(k, prefix_to_strip)] = v
	            result
	          }
	end

  # Convert prefixed PascalCase to snake_case, sans prefix
  # ex: rubyify_name('PrefixedFieldName', 'Prefixed') => 'field_name'
  def rubify_name(camelcase_name, prefix_to_strip)
    camelcase_name.sub(prefix_to_strip, '').underscore
  end

	# hack. This should go in a config file. TODO.
	def city
		'Mesa'
	end

	# set up logging and Legistar base settings
  def initialize
  	@@log = Logger.new(STDOUT)
    @@fileLog = Logger.new("fetch-legistar.log")
    @@log.level = Logger::DEBUG
    @@fileLog.level = Logger::DEBUG
    @@base_url = 'http://webapi.legistar.com'

		@@connection = Faraday.new(url: @@base_url) do |conn|
			conn.headers['Accept'] = 'text/json'
			conn.request :instrumentation
			conn.response :json
			conn.adapter Faraday.default_adapter
	  end
	end

  # given the URL of one of the Legistar documentation pages,
  # return the documented structure of the endpoint in a format
  # that is compatible with the Rails model creation migrations.
  def fetch_structure(url, endpoint_prefix_to_strip)
    connection = Faraday.new(:url => "https://api.import.io") do |conn|
      conn.request  :url_encoded             # form-encode POST params
      conn.response :logger                  # log requests to STDOUT
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
      puts response.body
      structure = ActiveSupport::JSON.decode(response.body)
      to_migration(structure, endpoint_prefix_to_strip)
    rescue => e
      bummer("query_url: #{url}, body: #{body}", response.status, e)
    end
  end

  # Take the structure described in the Legistar API and
  # output it in a format useful for a migration file.
  def to_migration(structure, prefix_to_strip)
    pp structure
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
  def rubify_type(type)
    case type
    when 'Collection of byte' then 'string'
    when 'date' then 'datetime'
    else type
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
	def fetch_nested_collection(endpoint,
															endpoint_filter,
															endpoint_prefix_to_strip,
															endpoint_class,
															nesting_endpoint,
															nesting_class)

		@@endpoint_class = endpoint_class #EventItem
		@@prefix_to_strip = endpoint_prefix_to_strip #'EventItem'
		@@endpoint = endpoint # 'EventItems'

    to_log("fetching from endpoint: #{endpoint} (nesting_endpoint: #{nesting_endpoint}), filter: #{endpoint_filter}, prefix: #{endpoint_prefix_to_strip}, class: #{endpoint_class}")

    # Event.all.each do |event|
    nesting_class.all.each do |nesting_item|
      begin

      	# url = "/Events/#{event.source_id}/EventItems"
			  url_path = "/v1/#{Legistar.city}/#{nesting_endpoint}/#{nesting_item.source_id}/#{endpoint}#{endpoint_filter}"
	      full_url = @@base_url + url_path

        response = @@connection.get(url_path)
        raise unless response.status == 200

	      to_objects(response.body)
        sleep 1

      rescue => e
      	bummer(full_url, response.status, e)
      end
    end
  end



	# endpoint: which endpoint in the Legistar API to fetch
	#          example: 'events' for fetching from /v1/#{Legistar.city}/events
	# endpoint_class: the Class of structure to create with the data retrieved from API
	#          example: Event
	def fetch_collection(endpoint, filter, prefix_to_strip, endpoint_class)
		@@prefix_to_strip = prefix_to_strip
		@@endpoint = endpoint
		@@endpoint_class = endpoint_class

    to_log("fetching from endpoint: #{endpoint}, filter: #{filter}, prefix: #{prefix_to_strip}, class: #{endpoint_class}")

    begin

      url_path = "/v1/#{Legistar.city}/#{endpoint}#{filter}"
      full_url = @@base_url + url_path

      response = @@connection.get(url_path)
      raise unless response.status == 200

      to_objects(response.body)
      sleep 1

    rescue => e
    	bummer(full_url, response.status, e)
    end
	end

	protected

	# collection: array of items returned from a Legistar collection endpoint
	def self.to_objects(collection)
		collection.each do |item|
		  attrs = rubify_object(item, @@prefix_to_strip)
		  attrs['source_id'] = attrs.delete('id')

		  pretty_attributes = pp attrs
		  msg = "Attempting creation of #{@@endpoint_class.to_s} with attrs: #{pretty_attributes}"
		  to_log(msg)

		  @@endpoint_class.create(attrs)
		end
	end

	def self.to_log(msg)
		@@log.info(msg)
		@@fileLog.info(msg)
	end

	# helper method to log fetch failure message
	def self.bummer(url, status, e)
	  msg = "Failed fetching #{url}, status: #{status}"
	  @@log.error(msg)
	  @@fileLog.error(msg)
	  @@log.error(e)
	  @@fileLog.error(e)
	end

end