# encoding: utf-8
module Gallifreyian
  class TranslationsController < ApplicationController
    respond_to :html, :js, :json
    helper_method :languages, :new_translation

    # GET /translations
    # GET /translations.js
    # GET /translations.json
    #
    def index
      new_translation
      respond_with(collection)
    end

    # GET /translations/new
    # GET /translations/new.js
    # GET /translations/new.json
    #
    def new
      respond_with(new_translation)
    end

    # POST /translations
    # POST /translations.js
    # POST /translations.json
    #
    def create
      respond_with(@translation = Gallifreyian::Translation.create(params[:translation]),
        location: translations_path)
    end

    # PUT /translations/:id
    # PUT /translations/:id.js
    # PUT /translations/:id.json
    #
    def update
      resource.update_attributes(params[:translation])
      respond_with(resource, location: translations_path)
    end

    # GET /translations/:id/edit
    # GET /translations/:id/edit.js
    # GET /translations/:id/edit.json
    #
    def edit
      respond_with(resource)
    end

    # DELETE /translations/:id
    # DELETE /translations/:id.js
    # DELETE /translations/:id.json
    #
    def destroy
      resource.destroy
      respond_with(resource, location: translations_path)
    end

    protected

    def languages
      params[:languages] || I18n.available_locales
    end

    def new_translation
      @translation ||= Gallifreyian::Translation.new
    end

    private

    def resource
      @translation ||= Gallifreyian::Translation.find(params[:id])
    end

    def collection
      @translations ||= Gallifreyian::Translation.where(language: Gallifreyian::Store.main_language).page(params[:page])
    end
  end
end
