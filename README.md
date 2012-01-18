# Gallifreyian

Gallifreyian provides an i18n backend, and a web interface as a Rails engine.

## Dependencies
  * ruby > 1.9.2
  * rails > 3.1
  * mongo
  * redis
  * elastic-search

## Installation

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

## Assets for translation interface

Require gallifreyian javascripts and stylesheets using the asset pipeline :

``` ruby
//= require gallifreyian/admin
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

### Installing on a fresh rails 3.2 app

TODO : merge in documentation

 * Add gallifreyian to your gemfile (FIXME : Remove this step, must be a gallifreyian dependency) :

``` ruby
gem 'mongoid_translate', git: 'af83@git.af83.com:mongoid_translate.git'
```

 * Add gallifreyian to your gemfile (FIXME : Use published gem, not git repo) :

``` ruby
gem 'gallifreyian', git: 'git@github.com:AF83/gallifreyian.git'
```

 * Run generators for mongoid and gallifreyian config :

``` bash
rails generate mongoid:config
rails generate gallifreyian:config
```

 * Import translations from config/locales/*.yml files

``` bash
rake gallifreyian:import
```

 * Mount Gallifreyian Engine in config/routes :

``` ruby
mount Gallifreyian::Engine => "/gallifreyian"
```

 * Require assets for gallifreyian admin interface :

  * Javascripts, in app/assets/javascripts/application.js :

``` ruby
//= require gallifreyian/admin
```

  * Stylesheets, in app/assets/javascripts/application.css :

``` ruby
//= require gallifreyian/admin
```

 * To enable gallifreyian javascript locales (locales prefix is js:)

  * include gallifreyian/i18next scripts in app/assets/javascripts/application.js :

``` ruby
//= require gallifreyian/i18next
```

 * Initialize i18next library, here is an example (see https://github.com/jamuhl/i18next for more informations) :

``` javascript
$(document).ready ->
  $.i18n.init
    lng: 'fr'
    fallbackLng: 'en'
    useLocalStorage: false
    ns: { namespaces: ['translation'], defaultNs: 'translation'}
    resGetPath: '/locales/__lng__.json'
  , ->
    // Boot your scripts using javascript locales in this callback.

```

  * Create json locales files :

``` bash
mkdir public/locales
rake gallifreyian:json_export
```

## Licence
-------

This project rocks and uses MIT-LICENSE.
