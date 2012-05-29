require "faye"
require "redis"
require "json"

uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379")
port = ENV["RHYBOO_ENV"].nil? ? 9000 : 1337
@redis = Redis.new(:host => uri.host, :port => uri.port, :driver => :synchrony)
@wsclient = Faye::Client.new("http://localhost:#{port}/faye")

EM.synchrony do
	@redis.subscribe(:rhyboo) do |on|
	  
	  on.message do |channel, message|
	    puts "##{channel}: #{message}"
	    msg = JSON.parse message
	    puts msg
	    msg["channels"].each do |channel|
	      @wsclient.publish "/rhyboo/#{channel}", msg["data"]
	    end
	  end
	end

end
