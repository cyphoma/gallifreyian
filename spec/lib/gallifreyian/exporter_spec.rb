# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Exporter do
  let(:exporter) { Gallifreyian::Exporter.new([:es, :en])}
  let(:dump_dir) { Gallifreyian::Exporter.dump_dir }

  before do
    (1..3).each do |i|
      Gallifreyian::Translation.create(key: "en.test#{i}", datum: "This is a test #{i}", language: :en)
    end
    Gallifreyian::Translation.create(key: "en.test.nested", datum: "This is a nested test", language: :en)
    Gallifreyian::Translation.create(key: "es.test.nested", datum: "This is a nested es test", language: :es)
    exporter.run
  end

  it "should dump a yaml file" do
    YAML.load_file(dump_dir.join('en.yml'))[:en][:test1].should eq "This is a test 1"
  end

  it 'should have all locales' do
    exporter.send(:all_translations).keys.should eq [:es, :en]
  end
end
