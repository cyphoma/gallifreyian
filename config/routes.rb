Gallifreyian::Engine.routes.draw do
  root to: "translations#index"
  resources :translations
end
