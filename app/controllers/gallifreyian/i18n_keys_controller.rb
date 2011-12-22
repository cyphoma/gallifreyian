# encoding: utf-8
module Gallifreyian
  class I18nKeysController < ApplicationController
    respond_to :html, :js, :json
    helper_method :languages, :new_i18n_key, :search_params

    # GET /i18n_keys
    # GET /i18n_keys.js
    # GET /i18n_keys.json
    #
    def index
      new_i18n_key
      respond_with(collection)
    end

    # GET /i18n_keys/new
    # GET /i18n_keys/new.js
    # GET /i18n_keys/new.json
    #
    def new
      respond_with(new_i18n_key)
    end

    # POST /i18n_keys
    # POST /i18n_keys.js
    # POST /i18n_keys.json
    #
    def create
      respond_with(@i18n_key = Gallifreyian::I18nKey.create(params[:i18n_key]),
        location: i18n_keys_path)
    end

    # PUT /i18n_keys/:id
    # PUT /i18n_keys/:id.js
    # PUT /i18n_keys/:id.json
    #
    def update
      resource.update_attributes(params[:i18n_key])
      respond_with(resource, location: i18n_keys_path)
    end

    # GET /i18n_keys/:id/edit
    # GET /i18n_keys/:id/edit.js
    # GET /i18n_keys/:id/edit.json
    #
    def edit
      respond_with(resource)
    end

    # DELETE /i18n_keys/:id
    # DELETE /i18n_keys/:id.js
    # DELETE /i18n_keys/:id.json
    #
    def destroy
      resource.destroy
      respond_with(resource, location: i18n_keys_path)
    end

    protected

    def languages
      params[:languages] || I18n.available_locales
    end

    def new_i18n_key
      @i18n_key ||=
        i18n_key = Gallifreyian::I18nKey.new
        i18n_key.translations.build(language: Gallifreyian::Configuration.main_language)
    end

    private

    def resource
      @i18n_key ||= Gallifreyian::I18nKey.find(params[:id])
    end

    def collection
      @i18n_keys ||= Gallifreyian::I18nKey.search(search_params)
    end

    def search_params
      if @search_params
        @search_params
      else
        @search_params = params[:search] || {}

        # Pagination params
        @search_params = Gallifreyian::Search.new(@search_params.merge!(params.slice('page', 'per_page')))
      end
    end
  end
end
