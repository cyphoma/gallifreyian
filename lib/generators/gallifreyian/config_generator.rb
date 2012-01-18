# encoding: utf-8

module Gallifreyian
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Gallifreyian initializer"
      class_option :orm

      def copy_initializer
        template "gallifreyian.rb", "config/initializers/gallifreyian.rb"
      end
    end
  end
end
