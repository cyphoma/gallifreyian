# encoding: utf-8
require 'i18n/core_ext/hash' # deep_merge

module Gallifreyian
  class Exporter

    delegate :dump_dir, to: "self.class"

    def initialize(locales = Gallifreyian::Configuration.available_locales)
      @locales = locales
    end

    def run
      raise "#{dump_dir} does not exist." unless File.exists?(dump_dir)
      @locales.each do |locale|
        File.open(dump_dir.join("#{locale}.yml"), 'w' ) do |out|
          out.write({locale => Gallifreyian::Store.all_translations[locale]}.to_yaml)
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

  end
end
