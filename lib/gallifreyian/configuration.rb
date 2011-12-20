# encoding: utf-8

module Gallifreyian
  class Configuration
    class << self

      attr_accessor :layout, :main_language

      def configure(&block)
        yield self
      end

    end
  end
end
