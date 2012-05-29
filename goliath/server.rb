require "faye"
require "logger"
require "./redis_sub.rb"

Faye::WebSocket.load_adapter('goliath')

@@connections = 0
@logger = Logger.new(STDOUT)

App = Faye::RackAdapter.new(
  :mount   => '/faye',
  :timeout => 60
)

App.bind(:handshake) do |client_id, channel|
  @@connections += 1
  @logger.warn "(c)connections: #{@@connections}"
end

App.bind(:disconnect) do |client_id|
  @@connections -= 1
  @logger.warn "(d)connections: #{@@connections}"
end

class Server < Goliath::API
  # default to JSON output, allow Yaml as secondary
  #use Goliath::Rack::Render, ['json', 'yaml']
  #plugin RedisSub

  def initialize
    super
  end

  def response(env)
    App.call(env)
  end
end