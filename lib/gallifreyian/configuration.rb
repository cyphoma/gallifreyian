# encoding: utf-8

module Gallifreyian
  class Configuration
    class << self

      attr_accessor :layout, :main_language, :helpers, :index_name,
        :js_locales
      attr_writer :available_locales

      def configure(&block)
        yield self
      end

      def helpers
        @helpers || []
      end

      def available_locales
        available_locales = @available_locales.present? ? @available_locales : I18n.available_locales
        Array(available_locales)
      end

    end
  end
end
