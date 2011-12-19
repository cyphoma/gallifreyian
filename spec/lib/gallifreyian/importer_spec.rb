# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Importer do
  before do
    Gallifreyian::Importer.new([Rails.root.join('config', 'locales', 'es.yml')]).run
  end

  it 'should have results' do
    Gallifreyian::I18nKey.all.should be_any
  end

  it 'should find by key' do
    Gallifreyian::I18nKey.where(key: 'activerecord.errors.template.body').
      one.should_not be_blank
  end

  it 'should find translation' do
    Gallifreyian::I18nKey.where(key: 'activerecord.errors.template.body').
      one.translations.where(language: :es).one.datum.should eq 'Se encontraron problemas con los siguientes campos:'

  end
end
