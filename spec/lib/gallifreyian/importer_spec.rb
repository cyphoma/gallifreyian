# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Importer do
  before do
    Gallifreyian::Importer.new(Rails.root.join('config', 'locales', 'es.yml')).run
  end

  it 'should have results' do
    Gallifreyian::Translation.all.should be_any
  end

  it 'should find by key' do
    Gallifreyian::Translation.where(key: 'es.activerecord.errors.template.body').
      one.datum.should eq 'Se encontraron problemas con los siguientes campos:'
  end
end
