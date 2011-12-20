# encoding: utf-8
#I18n.backend = Gallifreyian::Store.backend
Tire::Model::Search.index_prefix "gallyfreyian-#{Rails.env}"
Gallifreyian::Configuration.configure do |config|
  config.main_language = :en
  config.layout = 'application'
end
I18n.backend = I18n::Backend::Chain.new(Gallifreyian::Store.backend, I18n.backend)
