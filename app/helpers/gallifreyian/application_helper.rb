# encoding: utf-8
module Gallifreyian
  module ApplicationHelper
    def sibling_or_new(translation, language)
      translation.siblings.by_language(language).one || Gallifreyian::Translation.new(key: translation.key, language: language)
    end
  end
end
