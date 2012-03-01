# encoding: utf-8
Gallifreyian::Engine.routes.draw do
  root to: "i18n_keys#index"
  resources :i18n_keys do
    resources :translations, only: [] do
      member do
        post :validate
      end
    end
  end
end
