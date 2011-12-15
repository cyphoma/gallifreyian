# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'mongoid-rspec'
require 'faker'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Factories
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each { |f| require f }

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.include Mongoid::Matchers

  # clean database
  config.before(:each) do
    Mongoid.master.collections.select { |c|
      c.name != 'system.indexes'
    }.each(&:drop)
    Mongoid::IdentityMap.clear
    $gallifreyian_store.del '*'
  end

  config.after(:suite) do
    Mongoid.master.connection.drop_database(Mongoid.database.name)
  end

end
