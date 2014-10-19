#publisher: bundle exec rackup publisher.rb -p 9292
publisher: unicorn publisher.ru -p 9292 -c unicorn/production.rb
web_consumer: bundle exec unicorn web_consumer.ru -p 7777 -c unicorn/production.rb
cli_consumer: bundle exec ruby cli_consumer.rb
