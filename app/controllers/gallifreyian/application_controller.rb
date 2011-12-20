# encoding: utf-8
module Gallifreyian
  class ApplicationController < ActionController::Base
    layout :choose_layout

    private

    def choose_layout
      Gallifreyian::Configuration.layout || 'application'
    end
  end
end
