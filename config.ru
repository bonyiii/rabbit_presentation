$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'json'
require 'bundler/setup'
Bundler.require(:default, ENV.fetch("RACK_ENV") { "development" })

require File.expand_path("../publisher", __FILE__)

#require "sidekiq/web"

run Rack::URLMap.new(
  "/" => Publisher
)
