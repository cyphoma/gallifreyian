# encoding: utf-8
module Gallifreyian
  module ApplicationHelper
    def sibling_or_new(translation, language)
      translation.siblings.by_language(language).one || Gallifreyian::I18nKey.new(key: translation.key, language: language)
    end

    def hide_language?(language)
      if searched_languages.reject(&:blank?).include?(language.to_s)
        false
      elsif searched_languages.any?
        true
      else
        false
      end
    end

    def form_options(i18n_key)
      i18n_key.new_record? ? {} : {html: {:"data-remote" => true}}
    end
  end
end
