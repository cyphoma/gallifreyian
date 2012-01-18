# encoding: utf-8

Gallifreyian::Configuration.configure do |config|
  # Default language
  # config.main_language = :fr

  # Use a custom layout
  # config.layout = 'translation'

  # Send local app's helpers into Gallifreyian (can be usefull for custom layout)
  # config.helpers = MyApp::Application.helpers

  # Tire index name
  # config.index_name = Mongoid.database.name

  # will generate some json file compliant with i18next ( https://github.com/jamuhl/i18next )
  # config.js_locales = true
end

# Use Gallifreyian store with fallback on yaml file.
I18n.backend = I18n::Backend::Chain.new(Gallifreyian::Store.backend, I18n.backend)
