require 'demo_amqp'

#set :bind, '0.0.0.0'

DemoAmqp.connect

class Publisher < Sinatra::Base

  get '/' do
    erb :form
  end

  post '/message' do
    AMQP.channel.default_exchange.publish({ message: params[:message], lang: params[:lang], direction: params[:direction] }.to_json)
    redirect to('/')
  end
end
