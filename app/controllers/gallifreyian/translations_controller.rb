# encoding: utf-8
module Gallifreyian
  class TranslationsController < ApplicationController
    respond_to :html, :js, :json

    # GET /translations
    #
    def index
      respond_with(collection)
    end

    # GET /translations/new
    #
    def new
      respond_with(@translation = Gallifreyian::Translation.new)
    end

    # POST /translations
    #
    def create
      respond_with(@translation = Gallifreyian::Translation.create(params[:translation]))
    end

    # PUT /translations/:id
    #
    def update
      respond_with(@translation = resource.update_attributes(params[:translation]))
    end

    # GET /translations/:id/edit
    #
    def edit
      respond_with(resource)
    end

    # DELETE /translations/:id
    #
    def destroy
      resource.destroy
      respond_with(resource, location: translations_path)
    end

    private

    def resource
      @translation ||= Gallifreyian::Translation.find(params[:id])
    end

    def collection
      @translations ||= Gallifreyian::Translation.all.to_a
    end
  end
end
