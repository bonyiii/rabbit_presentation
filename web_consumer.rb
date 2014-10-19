# encoding: utf-8

$amqp = DemoAmqp.new
$amqp.connect
$amqp.listen

class WebConsumer < Sinatra::Base
  get "/" do
    erb :web_consumer
  end
end
