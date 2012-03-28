# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Search do

  describe 'callback' do
    it 'should remove empty string from languages' do
      Gallifreyian::Search.new(languages: ['', '', 'test']).languages.should eq ['test']
    end

    it 'should cast languages as an array' do
      Gallifreyian::Search.new(languages: 'test').languages.should eq ['test']
    end
  end

end
