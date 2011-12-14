# encoding: utf-8
module Gallifreyian
  class Engine < Rails::Engine
    isolate_namespace Gallifreyian

    rake_tasks do
      load 'lib/tasks/gallifreyian.rake'
    end
  end
end
