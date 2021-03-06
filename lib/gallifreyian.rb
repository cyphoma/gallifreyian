# encoding: utf-8

# See: https://github.com/carlhuda/bundler/issues/1096
# require 'bundler'
#Bundler.require(:default)

require 'yajl/json_gem'
require 'mongoid'
require 'kaminari'
require 'simple_form'
require 'tire'
require 'addressable/uri'

Dir["#{File.dirname(__FILE__)}/gallifreyian/**/*.rb"].each { |f| require f }

module Gallifreyian
end
