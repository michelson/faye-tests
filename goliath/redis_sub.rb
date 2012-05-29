require "redis"
require "json"

class RedisSub
  
  def initialize(port, config, status, logger)
		uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379")
		@redis = Redis.new(:host => uri.host, :port => uri.port, :driver => :synchrony)
  end

  def run
		@redis.subscribe(:rhyboo) do |on|
		  
		  on.message do |channel, message|
		    puts "##{channel}: #{message}"
		    msg = JSON.parse message
		    puts msg
		    msg["channels"].each do |channel|
		      App.get_client.publish "/rhyboo/#{channel}", msg["data"]
		    end
		  end
		end  
  end
end