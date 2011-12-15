# encoding: utf-8

namespace :gallifreyian do

  desc "Import YAML locales files"
  task :import => :environment do
    paths = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    Gallifreyian::Importer.new(paths).run
  end

  desc "Export YAML locales files"
  task :export => :environment do
    Gallifreyian::Exporter.new.run
  end
end
