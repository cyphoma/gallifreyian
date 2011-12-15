# encoding: utf-8
require 'i18n/core_ext/hash' # deep_merge

module Gallifreyian
  class Exporter

    def initialize(locales)
      @locales = locales
    end

    def run
      @locales.each do |locale|
        #all_translations[locale]
      end
    end

    protected

    def to_deep_hash(locale)
      Gallifreyian::Translation.where(language: locale).all.inject({}) do |hash, translation|
        tmp_hash = {}
        translation.key.split('.').reverse.each_with_index do |key, index|
          if index == 0
            tmp_hash = {:"#{key}" => translation.datum}
          else
            tmp_hash = {:"#{key}" => tmp_hash}
          end
        end
        hash.deep_merge!(tmp_hash)
      end
    end

    def all_translations
      @all_translations ||= @locales.inject({}) do |hash, locale|
        hash.merge(self.to_deep_hash(locale))
      end
    end
  end
end
