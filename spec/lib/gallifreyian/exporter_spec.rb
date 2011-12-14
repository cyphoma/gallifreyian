# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Exporter do
  before do
    (1..3).each do |i|
      Gallifreyian::Translation.new(key: "en.test#{i}", datum: "This is a test #{i}", language: :en)
    end
    Gallifreyian::Exporter.new([:en]).run
  end

  it "should dump a yaml file" do
    YAML.load_file(Rails.root.join('config', 'locales', 'dumps', 'en.yml'))['en']['test1'].should eq
    "This is a test 1"
  end
end
