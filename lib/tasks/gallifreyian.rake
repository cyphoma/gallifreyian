# encoding: utf-8

namespace :gallifreyian do

  desc "Import YAML files"
  task :import => :environment do
    paths = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    Gallifreyian::Importer.new(paths).run
  end
end
