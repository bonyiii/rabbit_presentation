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
