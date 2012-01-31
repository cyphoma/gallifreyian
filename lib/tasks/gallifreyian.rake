# encoding: utf-8

namespace :gallifreyian do

  desc "Import new keys from YAML locales files"
  task :import => :environment do
    paths = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    Gallifreyian::Importer.new(paths).run
  end

  desc "Destroy and seeds keys from YAML locales files"
  task :seed => :environment do
    paths = Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    Gallifreyian::Seed.new(paths).run
  end

  desc "Export YAML locales files"
  task :export => :environment do
    Gallifreyian::Exporter.run
  end

  desc "Export JSON locales files"
  task :json_export => :environment do
    Gallifreyian::JsonExporter.run
  end

  namespace :es do

    desc "Recreate index and reindex translations for ES/Tire"
    task :rebuild_index => :environment do
      Gallifreyian::I18nKey.instance_eval do
        # We need a paginate method on the model to feed the records in batch
        # see https://github.com/karmi/tire/issues/48#issuecomment-1499519
        def self.paginate(options = {})
          page(options[:page]).per(options[:per_page])
        end
      end

      puts "Deleting index #{Gallifreyian::I18nKey.tire.index.name}"
      Gallifreyian::I18nKey.tire.index.delete
      puts "Recreating index #{Gallifreyian::I18nKey.tire.index.name}"
      Gallifreyian::I18nKey.create_elasticsearch_index
      puts "Preparing to reindex #{Gallifreyian::I18nKey.count} #{Gallifreyian::I18nKey} records, latest first"
      Gallifreyian::I18nKey.import
    end

  end
end
