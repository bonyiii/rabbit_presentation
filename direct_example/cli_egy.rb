#!/usr/bin/env ruby
# encoding: utf-8

require 'bundler'
Bundler.setup(:default, ENV.fetch("RACK_ENV") { "development" })
require 'amqp'

AMQP.start do |connection, open_ok|
  channel  = AMQP::Channel.new(connection)
  exchange = channel.direct("testing_direct", auto_delete: true)

  # This way messages with routing key "egy" will be delivered here.
  q = channel.queue("direct_queue1", auto_delete: true).bind(exchange, routing_key: "egy")
  q.subscribe do |payload|
    puts "Received a message: #{payload.inspect}."

    #connection.close { EventMachine.stop }
  end

  EventMachine.add_timer(0.5) do
    puts "=> Publishing..."
    exchange.publish("From Egy, Ohai! To Egy", routing_key: "egy")
    exchange.publish("From Egy, Ohai! To Ketto", routing_key: "ketto")
  end
end
