# encoding: utf-8
module Gallifreyian
  class Store
    class << self
      def backend
        I18n::Backend::KeyValue.new($gallifreyian_store)
      end

      def save(translation)
        self.backend.store_translations(translation.language, {translation.key => translation.datum}, escape: false)
      end

      def bootstrap
        Gallifreyian::Translation.all.each do |translation|
          self.save(translation)
        end
      end
    end
  end
end