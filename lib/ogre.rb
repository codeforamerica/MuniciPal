require 'faraday'

module Ogre
	def self.convert(file,source_srs,target_srs)
	    @url = 'http://ogre.adc4gis.com/'

	    @connection = Faraday.new(url: @url ) do |conn|
	      conn.headers['Accept'] = 'text/json'
	      conn.request :instrumentation
	      conn.response :json
	      conn.adapter Faraday.default_adapter
	      conn.request :retry, max: 5, interval: 0.05, interval: 0.05, interval_randomness: 0.5, backoff_factor: 2
	    end

		@connection.post do |req|    
		  req.url '/convert'
		  req.params['upload'] = file
		  req.params['sourceSrs'] = source_srs
		  req.params['targetSrs'] = target_srs
		end
	end
end