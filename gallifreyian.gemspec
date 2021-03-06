$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gallifreyian/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gallifreyian"
  s.version     = Gallifreyian::VERSION
  s.authors     = ["chatgris", "Romain Gauthier"]
  s.email       = ["jboyer@af83.com", "romain.gauthier@af83.com"]
  s.summary     = "I18N web ui and store."
  s.description = "I18N web ui and store."

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["specs/**/*"]
  s.require_path = 'lib'

  s.add_dependency "rails", "~> 3.1"
  s.add_dependency "mongoid"
  s.add_dependency "bson_ext"
  s.add_dependency "sanitize"
  s.add_dependency "yajl-ruby"
  s.add_dependency "kaminari"
  s.add_dependency "redis-namespace"
  s.add_dependency "simple_form"
  s.add_dependency 'tire'
  s.add_dependency 'addressable'

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'mongoid-rspec'
  s.add_development_dependency "faker"
end
