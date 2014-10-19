#!/usr/bin/env ruby
# encoding: utf-8

require 'json'
require 'bundler'
Bundler.setup(:default, ENV.fetch("RACK_ENV") { "development" })
require 'amqp'

AMQP.start do |connection, open_ok|
  channel  = AMQP::Channel.new(connection)
  exchange = channel.fanout("testing")

  channel.queue("heywait") do |queue|
    queue.bind(exchange).subscribe do |metadata, payload|
      puts "Received a message: #{payload.inspect}."

      #connection.close { EventMachine.stop }
    end

    EventMachine.add_timer(0.2) do
      puts "=> Publishing..."
      exchange.publish("Ohai!")
    end
  end
end

