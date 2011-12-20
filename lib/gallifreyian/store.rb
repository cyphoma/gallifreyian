# encoding: utf-8
module Gallifreyian
  class Store
    class << self

      def backend
        I18n::Backend::KeyValue.new($gallifreyian_store)
      end

      def save(i18n)
        i18n.translations.each do |translation|
          if translation.datum.present?
            self.backend.store_translations(translation.language, {i18n.key => translation.datum}, escape: false)
          end
        end
      end

      def all_translations(section = nil)
        collection = Gallifreyian::I18nKey.all
        if section
          collection.where(section: section)
        end
        collection.inject({}) do |hash, i18n_key|
          tmp_hash = {}
          new_hash = {}
          i18n_key.translations.each do |translation|
            [translation.language.to_s, i18n_key.key].join('.').
            split('.').reverse.each_with_index do |key, index|
              if index == 0
                tmp_hash = {:"#{key}" => translation.datum.to_s}
              else
                tmp_hash = {:"#{key}" => tmp_hash}
              end
            end
            new_hash.merge!(tmp_hash)
          end
          hash.deep_merge!(new_hash)
        end
      end

      def bootstrap
        Gallifreyian::I18nKey.all.each do |i18n_key|
          self.save(i18n_key)
        end
      end
    end
  end
end
