$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'bundler'
Bundler.require(:default, ENV.fetch("RACK_ENV") { "development" })
require 'demo_amqp'
require File.expand_path("../publisher", __FILE__)

run Publisher
