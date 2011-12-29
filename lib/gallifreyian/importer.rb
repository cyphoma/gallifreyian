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
            start = language.length + 1
            i18n_key = Gallifreyian::I18nKey.find_or_initialize_by(key: key.slice(start..-1))
            i18n_key.translations.find_or_initialize_by(language: language)
            i18n_key.translations.where(language: language).one.datum = datum
            if i18n_key.save
              count += 1
            else
              i18n_key.errors.messages.each do |field, message|
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
