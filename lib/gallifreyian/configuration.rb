# encoding: utf-8

module Gallifreyian
  class Configuration
    class << self

      attr_accessor :layout, :main_language, :helpers, :index_name

      def configure(&block)
        yield self
      end

      def helpers
        @helpers || []
      end

    end
  end
end
