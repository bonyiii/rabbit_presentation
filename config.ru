require File.expand_path("../publisher", __FILE__)

#require "sidekiq/web"

run Rack::URLMap.new(
  "/" => Publisher
)
