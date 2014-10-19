#!/usr/bin/env ruby
# encoding: utf-8
$stdout.sync = true

require 'json'
require 'bundler'
Bundler.setup(:default, ENV.fetch("RACK_ENV") { "development" })
require 'amqp'

AMQP.start do |connection, open_ok|
  channel  = AMQP::Channel.new(connection)
  exchange = channel.direct("testing_direct", auto_delete: true)

  # If channel would have same name as in cli_egy "direct_queue1" then this queue would have two bindings "egy", "ketto"
  # messages would be sorted among customers equally, but any customers could could receive any message that 
  # has routing key "egy" or "ketto"
  #channel.queue("direct_queue1", auto_delete: true) do |queue|
  #
  # This way "direct_queue2" will have only one routing key and consumer of this queue will only receive messages
  # with routing key "ketto"
  channel.queue("direct_queue2", auto_delete: true) do |queue|
    # If routing key is same as cli_egy, "egy" it would receive the same messages as cli_egy.
    # So every second message would be delivered to two destination and the rest would be dropped.
    #queue.bind(exchange, routing_key: "egy").subscribe do |metadata, payload|
    #
    # This way messages with routing key "ketto" will be delivered here.
    queue.bind(exchange, routing_key: "ketto").subscribe do |metadata, payload|
      #puts metadata.routing_key
      puts "Received a message: #{payload.inspect}."

      #connection.close { EventMachine.stop }
    end

    EventMachine.add_timer(0.5) do
      puts "=> Publishing..."
      exchange.publish("From Ketto, Ohai! To Ketto", routing_key: "ketto")
      exchange.publish("From Ketto, Ohai! To Egy", routing_key: "egy")
    end
  end
end

