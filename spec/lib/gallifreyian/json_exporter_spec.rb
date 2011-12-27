# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::JsonExporter do
  let(:exporter) { Gallifreyian::JsonExporter.new([:es, :en])}
  let(:dump_dir) { Gallifreyian::JsonExporter.dump_dir }

  before do
    (1..3).each do |i|
      g = Gallifreyian::I18nKey.new(key: "js.test#{i}")
      g.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a test #{i}", language: :en)
      g.save
    end
    key = Gallifreyian::I18nKey.new(key: "js.nested")
    key.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a nested test", language: :en)
    key.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a nested test", language: :es)
    key.save
    exporter.run
  end

  it "should dump a json file" do
    content = File.read(dump_dir.join('en.json'))
    JSON.parse(content)['test1'].should eq "This is a test 1"
  end

  it 'should have all locales' do
    locales = Gallifreyian::Store.all_translations.keys
    locales.should_not be_empty
    I18n.available_locales.each do |locale|
      locales.include?(locale).should be_true
    end
  end
end

