# encoding: utf-8
require 'i18n/core_ext/hash' # deep_merge

module Gallifreyian
  class Exporter

    delegate :dump_dir, to: "self.class"

    def initialize(locales = I18n.available_locales)
      @locales = locales
    end

    def run
      raise "#{dump_dir} does not exist." unless File.exists?(dump_dir)
      @locales.each do |locale|
        open(dump_dir.join("#{locale}.yml"), 'w').write({locale => all_translations[locale]}.to_yaml)
      end
    end

    class << self
      def run
        self.new.run
      end

      def dump_dir
        Rails.root.join('config', 'gallifreyian')
      end
    end

    protected

    def to_deep_hash(locale)
      Gallifreyian::Translation.where(language: locale).all.inject({}) do |hash, translation|
        tmp_hash = {}
        translation.key.split('.').reverse.each_with_index do |key, index|
          if index == 0
            tmp_hash = {:"#{key}" => translation.datum.to_s}
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
