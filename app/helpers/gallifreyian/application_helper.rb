# encoding: utf-8
module Gallifreyian
  module ApplicationHelper
    def sibling_or_new(translation, language)
      translation.siblings.by_language(language).one || Gallifreyian::I18nKey.new(key: translation.key, language: language)
    end

    def hidden_unless_select(language)
      if params[:search] && params[:search][:languages] && params[:search][:languages].include?(language.to_s)
        type = :text
      elsif params[:search] && params[:search][:languages] && params[:search][:languages].any?
        :hidden
      else
        :text
      end
    end
  end
end
