# encoding: utf-8
module Gallifreyian
  class TranslationObserver < Mongoid::Observer
    def after_save(translation)
      Gallifreyian::Store.backend.
        store_translations(translation.language, {translation.key => translation.datum}, escape: false)
    end
  end
end

Mongoid.observers = Gallifreyian::TranslationObserver
Mongoid.instantiate_observers
