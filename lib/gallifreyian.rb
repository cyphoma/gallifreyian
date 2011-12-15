# encoding: utf-8

require 'yajl/json_gem'
require 'mongoid'
Dir["#{File.dirname(__FILE__)}/gallifreyian/**/*.rb"].each { |f| require f }

module Gallifreyian
end
