# Gallifreyian

Gallifreyian provides an i18n backend, and a web interface as a Rails engine.

## Dependencies
  * mongo
  * redis
  * elastic-search

## Installation

Ruby 1.9.2 is required.

With bundler, add it to your `Gemfile`:

``` ruby
gem "gallifreyian", git: "path.to.repository"
```

As a rails engine, Gallifreyian can be mounted in a rails app using routes.

``` ruby
MyApp::Application.routes.draw do
  mount Gallifreyian::Engine => "/translations"
end
```

Using devise for authentification :

``` ruby
MyApp::Application.routes.draw do
  devise_for :administrators
  authenticate :administrator do
    mount Gallifreyian::Engine => "/translations"
  end
end
```

An initializer is needed :

``` ruby
# encoding: utf-8

Gallifreyian::Configuration.configure do |config|
  config.main_language = :fr                   # default language
  config.layout = 'translation'                # use a custom layout
  config.helpers = MyApp::Application.helpers  # send local app's helpers into Gallifreyian (can be usefull for custom layout)
  config.index_name = Mongoid.database.name    # Tire index name
  config.js_locales = true                     # will generate some json file compliant with i18next ( https://github.com/jamuhl/i18next )
end

# Use Gallifreyian store with fallback on yaml file.
I18n.backend = I18n::Backend::Chain.new(Gallifreyian::Store.backend, I18n.backend)
```

## TODO

  * test in a non-mongoid app
  * better elastic search indexing
  * more specs

## MAYBE TODO

  * Tire as main persistence engine, instead of mongo ?
  * c3po ? can be difficult because of interpolations.

## Notes

Docs about engine: http://edgeapi.rubyonrails.org/classes/Rails/Engine.html

## Licence
-------

This project rocks and uses MIT-LICENSE.
