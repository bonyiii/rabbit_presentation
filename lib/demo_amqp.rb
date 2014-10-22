require 'json'

class DemoAmqp

  attr_reader :exchange, :gyula

  def self.connect
    new.connect
  end

  def initalize

  end

  def connect
    t = Thread.new { AMQP.start }
    sleep(1.0)
    EventMachine.next_tick do
      @channel ||= AMQP::Channel.new(AMQP.connection)
      @exchange = @channel.fanout("testing")
      @gyula = @channel.direct("gyula")
      1.times do |i|
        exchange.publish("A warmup message #{i} from #{Time.now.strftime('%H:%M:%S %m/%b/%Y')}", :routing_key => "amqpgem.examples.rails23.warmup")
        puts "Publishing a warmup message ##{i}"
      end
    end
  end

  def send(message)
    EM.next_tick do
      $amqp.exchange.publish(message.to_json)
      $amqp.gyula.publish(message.to_json, routing_key: "rabbit")
    end
  end

  def listen
    EventMachine.next_tick do
      queue ||= @channel.queue("web_consumer", auto_delete: true).bind(exchange)
      queue.subscribe do |payload|
        puts payload
      end
    end
  end
end
