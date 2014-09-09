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
	# rubify_name(camel, 'Camel')
	# => {"first_name"=>"Ed", "last_name"=>"Jones"}
	#
	def rubify_name(camelcase_object, prefix_to_strip)
	  attrs = camelcase_object.reduce({}){ |result, (k,v)|
	            result[k.sub(prefix_to_strip, '').underscore] = v
	            # result[k.underscore.sub(prefix_to_strip, '')] = v
	            result
	          }
	end

	# hack. This should go in a config file. TODO.
	def city
		'Mesa'
	end


	# endpoint: which endpoint in the Legistar API to fetch
	#          example: 'events' for fetching from /v1/#{Legistar.city}/events
	# endpoint_class: the Class of thing to create with the data retrieved from API
	#          example: Event
	def fetch_collection(endpoint, filter, prefix_to_strip, endpoint_class)
		log = Logger.new(STDOUT)
	    fileLog = Logger.new("fetch-#{endpoint}.log")
	    log.level = fileLog.level = Logger::DEBUG
	    url = nil

        log.info("fetching from endpoint: #{endpoint}, filter: #{filter}, prefix: #{prefix_to_strip}, class: #{endpoint_class}")


	    connection = Faraday.new(url: 'http://webapi.legistar.com') do |conn|
	      conn.headers['Accept'] = 'text/json'
	      conn.request :instrumentation
	      conn.response :json
	      conn.adapter Faraday.default_adapter
	      url = conn.url_prefix.to_s
	    end

	    begin
	      url_path = "/v1/#{Legistar.city}/#{endpoint}#{filter}"

	      response = connection.get(url_path)
	      url = url + url_path
	      status = response.status

	      raise unless status == 200

	      collection = response.body

	      collection.each do |item|
	        attrs = Legistar.rubify_name(item, prefix_to_strip)
	        attrs['source_id'] = attrs.delete('id')

	        pretty_attributes = pp attrs
	        msg = "Attempting creation of #{endpoint} with attrs: #{pretty_attributes}"
	        log.info(msg)
	        fileLog.info(msg)

	        endpoint_class.create(attrs)
	      end

	      sleep 1
	    rescue => e
	      msg = "Failed fetching #{url}, status: #{status}"
	      log.error(msg)
	      fileLog.error(msg)
	      log.error(e)
	      fileLog.error(e)
	    end
	end
end