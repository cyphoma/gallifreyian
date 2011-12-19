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
        File.open(dump_dir.join("#{locale}.yml"), 'w' ) do |out|
          out.write({locale => all_translations[locale]}.to_yaml)
        end
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

    def to_deep_hash
      Gallifreyian::I18nKey.all.inject({}) do |hash, i18n_key|
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

    def all_translations
      @all_translations ||= self.to_deep_hash
    end
  end
end
