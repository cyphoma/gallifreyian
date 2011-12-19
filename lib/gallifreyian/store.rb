# encoding: utf-8
module Gallifreyian
  class Store
    class << self
      attr_accessor :main_language

      def backend
        I18n::Backend::KeyValue.new($gallifreyian_store)
      end

      def save(i18n)
        i18n.translations.each do |translation|
          self.backend.store_translations(translation.language, {i18n.key => translation.datum}, escape: false)
        end
      end

      def bootstrap
        Gallifreyian::I18nKey.all.each do |translation|
          self.save(translation)
        end
      end
    end
  end
end
