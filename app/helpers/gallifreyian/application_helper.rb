# encoding: utf-8
module Gallifreyian
  module ApplicationHelper
    def sibling_or_new(translation, language)
      translation.siblings.by_language(language).one || Gallifreyian::I18nKey.new(key: translation.key, language: language)
    end

    def hide_language?(translation)
      if translation.language == Gallifreyian::Configuration.main_language
        false
      elsif searched_languages.reject(&:blank?).include?(translation.language.to_s)
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

    def selected_section(section)
      if params[:search] && params[:search][:section] && params[:search][:section] == section
        " selected"
      end
    end
  end
end
