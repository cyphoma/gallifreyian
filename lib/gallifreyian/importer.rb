# encoding: utf-8
module Gallifreyian
  class Importer
    include I18n::Backend::Flatten

    def initialize(paths)
      @paths = paths
    end

    def run
      count = 0
      @paths.flatten.each do |path|
        translations = YAML.load_file(path)
        language = translations.keys.first

        flatten_keys(translations, false) do |key, datum|
          unless datum.is_a? Hash
            translation = Gallifreyian::Translation.create(key: key, datum: datum, language: language)
            if translation.valid?
              count += 1
            else
              translation.errors.messages.each do |field, message|
                warn "#{field} invalid: #{message}"
              end
            end
          end
        end
      end

      p "#{count} translations were imported."
    end
  end
end
