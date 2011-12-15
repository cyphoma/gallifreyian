# encoding: utf-8
module Gallifreyian
  class Store
    class << self
      def backend
        I18n::Backend::KeyValue.new($gallifreyian_store)
      end
    end
  end
end
