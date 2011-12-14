# encoding: utf-8
module Gallifreyian
  class Importer
    include I18n::Backend::Flatten

    def initialize(*paths)
      @paths = paths
    end

    def run
      @paths.each do |path|
        translations = YAML.load_file(path)
        language = translations.keys.first

        flatten_keys(translations, false) do |key, datum|
          unless datum.is_a? Hash
            Gallifreyian::Translation.create(key: key, datum: datum, language: language)
          end
        end
      end
    end
  end
end
