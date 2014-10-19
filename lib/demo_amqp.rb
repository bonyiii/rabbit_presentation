require 'json'

class DemoAmqp

  attr_reader :exchange

  def self.connect
    new.connect
  end

  def initalize

  end

  def connect
    t = Thread.new { AMQP.start }
    sleep(1.0)
    EventMachine.next_tick do
      channel ||= AMQP::Channel.new(AMQP.connection)
      @exchange = channel.fanout("testing")
      1.times do |i|
        exchange.publish("A warmup message #{i} from #{Time.now.strftime('%H:%M:%S %m/%b/%Y')}", :routing_key => "amqpgem.examples.rails23.warmup")
        puts "Publishing a warmup message ##{i}"
      end
    end
  end

  def send(message)
    EM.next_tick do
      $amqp.exchange.publish(message.to_json)
    end
  end
end
