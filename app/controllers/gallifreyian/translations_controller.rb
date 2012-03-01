# encoding: utf-8
module Gallifreyian
  class TranslationsController < ApplicationController
    respond_to :html, :js, :json

    def validate
      translation.validate!
    end

    private

    def resource
      @i18n_key ||= Gallifreyian::I18nKey.find(params[:i18n_key_id])
    end

    def translation
      @translation ||= resource.translations.where(_id: params[:id]).one
    end
  end
end

