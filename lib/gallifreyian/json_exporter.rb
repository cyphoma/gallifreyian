# encoding: utf-8
require 'i18n/core_ext/hash' # deep_merge

module Gallifreyian
  class JsonExporter

    delegate :dump_dir, to: "self.class"

    def initialize(locales = I18n.available_locales)
      @locales = locales
    end

    def run
      raise "#{dump_dir} does not exist." unless File.exists?(dump_dir)
      translations = Gallifreyian::Store.all_translations
      @locales.each do |locale|
        File.open(dump_dir.join("#{locale}.json"), 'w' ) do |out|
          out.write(translations[locale][:js].to_json)
        end
      end
    end

    class << self
      def run
        self.new.run
      end

      def dump_dir
        Rails.root.join('public', 'locales')
      end
    end

  end
end

