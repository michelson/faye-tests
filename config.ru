require 'faye'
require 'faye/redis'
require "./faye_app"
Faye::WebSocket.load_adapter('goliath')

run App