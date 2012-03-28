# encoding: utf-8
module Gallifreyian
  class ApplicationController < ActionController::Base
    layout :choose_layout
    helper Gallifreyian::Configuration.helpers
    helper_method :searched_languages

    def searched_languages
      search_params = params[:search] || {}
      (search_params[:languages] || referer_languages || Gallifreyian::Configuration.available_locales).reject(&:blank?)
    end

    private

    def choose_layout
      Gallifreyian::Configuration.layout || 'application'
    end

    def referer_languages
      query = ::Addressable::URI.parse(request.referer)
      if query && query.query_values
        search = query.query_values['search'] || {}
        search['languages'] || []
      else
        []
      end
    end
  end
end
