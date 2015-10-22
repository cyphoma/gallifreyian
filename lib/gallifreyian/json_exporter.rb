# encoding: utf-8
require 'i18n/core_ext/hash' # deep_merge

module Gallifreyian
  class JsonExporter

    delegate :dump_dir, to: "self.class"

    def initialize(locales = Gallifreyian::Configuration.available_locales)
      @locales = locales
    end

    def run
      raise "#{dump_dir} does not exist." unless File.exists?(dump_dir)
      translations = Gallifreyian::Store.all_translations
      manifest = {}
      @locales.each do |locale|
        if translations[locale]
          filename = locale_filename(locale)
          File.open(dump_dir.join(filename), 'w' ) do |out|
            out.write(translations[locale][:js].to_json)
          end
          manifest["#{locale}.json"] = filename
        end
      end
      File.write(File.join(dump_dir, "manifest.json"), manifest.to_json)
    end

    class << self
      def run
        self.new.run
      end

      def dump_dir
        Rails.root.join('public', 'locales')
      end
    end

    private

    def locale_filename(locale)
      if Rails.configuration.assets.digest
        @digest ||= SecureRandom.hex
        "#{locale}-#{@digest}.json"
      else
        "#{locale}.json"
      end
    end

  end
end

