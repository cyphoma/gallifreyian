# encoding: utf-8
module Gallifreyian
  class TranslationObserver < Mongoid::Observer
    def after_save(translation)
      Gallifreyian::Store.save(translation)
    end
  end
end

Mongoid.observers = Gallifreyian::TranslationObserver
Mongoid.instantiate_observers
