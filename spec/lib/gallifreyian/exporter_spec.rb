# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Exporter do
  let(:exporter) { Gallifreyian::Exporter.new([:es, :en])}
  let(:dump_dir) { Gallifreyian::Exporter.dump_dir }

  before do
    (1..3).each do |i|
      g = Gallifreyian::I18nKey.new(key: "test#{i}")
      g.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a test #{i}", language: :en)
      g.save
    end
    key = Gallifreyian::I18nKey.new(key: "test.nested")
    key.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a nested test", language: :en)
    key.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a nested test", language: :es)
    key.save
    exporter.run
  end

  it "should dump a yaml file" do
    YAML.load_file(dump_dir.join('en.yml'))[:en][:test1].should eq "This is a test 1"
  end

  it 'should have all locales' do
    exporter.send(:all_translations).keys.should eq [:en, :es]
  end
end
