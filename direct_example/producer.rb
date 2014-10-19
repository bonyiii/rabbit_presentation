#!/usr/bin/env ruby
# encoding: utf-8

require 'json'
require 'bundler'
Bundler.setup(:default, ENV.fetch("RACK_ENV") { "development" })
require 'amqp'

AMQP.start do |connection, open_ok|
  channel  = AMQP::Channel.new(connection)
  exchange = channel.direct("testing_direct", auto_delete: true)

  10.times do |i|
    routing_key = (i % 2 == 0) ? "egy" : "ketto"
    exchange.publish({ message: "message body #{i}" }.to_json, routing_key: routing_key)
  end

  show_stopper = Proc.new do
    $stdout.puts "Stopping..."
    connection.close { EventMachine.stop }
  end

  Signal.trap "INT", show_stopper
  EventMachine.add_timer(1, show_stopper)
end
