# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Importer do
  before do
    Gallifreyian::Importer.new([Rails.root.join('config', 'locales', 'es.yml'), Rails.root.join('config', 'locales', 'en.yml')]).run
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

  it "should find translations for each imported language" do
    Gallifreyian::I18nKey.where(key: 'hello').
      one.translations.where(language: :es).one.datum.should eq 'Hola Mundo'
    Gallifreyian::I18nKey.where(key: 'hello').
      one.translations.where(language: :en).one.datum.should eq 'Hello world'
  end
end
