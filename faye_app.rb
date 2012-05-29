require "faye"
require "logger"

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