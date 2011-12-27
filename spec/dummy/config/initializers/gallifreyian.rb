# encoding: utf-8
#
Tire::Model::Search.index_prefix "gallyfreyian-#{Rails.env}"

Gallifreyian::Configuration.configure do |config|
  config.main_language = :en
  config.layout = 'application'
  config.js_locales = true
end

I18n.backend = I18n::Backend::Chain.new(Gallifreyian::Store.backend, I18n.backend)
