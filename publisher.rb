$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'bundler'
Bundler.require(:default, ENV.fetch("RACK_ENV") { "development" })
require 'demo_amqp'

#set :bind, '0.0.0.0'

$amqp = DemoAmqp.new
$amqp.connect

class Publisher < Sinatra::Base

  get '/' do
    erb :form
  end

  post '/message' do
    $amqp.send({ message: params[:message], lang: params[:lang], direction: params[:direction] })
    redirect to('/')
  end
end
