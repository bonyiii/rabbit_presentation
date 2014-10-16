$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
#$LOAD_PATH.unshift(File.expand_path('../lib/amqp', __FILE__))

require 'json'
require 'bundler/setup'
Bundler.require(:default, ENV.fetch("RACK_ENV") { "development" })


class Publisher < Sinatra::Base

  get '/' do
    erb :form
  end

  post '/message' do
    AMQP.start("amqp://127.0.0.1:5672") do |connection|
      channel  = AMQP::Channel.new(connection)
      queue    = channel.queue("amqpgem.examples.helloworld", :auto_delete => true)
      exchange = channel.fanout("testing")
      puts params.inspect
      exchange.publish({ message: params[:message], lang: params[:lang], direction: params[:direction] }.to_json)
      puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."
      EventMachine.add_timer(2) do
        exchange.delete

        connection.close { EventMachine.stop }
      end
    end
    redirect to('/')
  end
end
