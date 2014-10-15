$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'bundler/setup'
Bundler.require(:default, ENV.fetch("RACK_ENV") { "default" })


class Publisher < Sinatra::Base

end
