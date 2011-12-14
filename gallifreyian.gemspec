$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gallifreyian/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gallifreyian"
  s.version     = Gallifreyian::VERSION
  s.authors     = ["chatgris", "Romain Gauthier"]
  s.email       = ["jboyer@af83.com", "romain.gauthier@af83.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Gallifreyian."
  s.description = "TODO: Description of Gallifreyian."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["specs/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "mongoid"
  s.add_dependency "bson_ext"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'mongoid-rspec'
  s.add_development_dependency "faker"
end
