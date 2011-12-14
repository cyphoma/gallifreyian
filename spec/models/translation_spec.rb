# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Translation do
  it 'should be defined' do
    defined?(Gallifreyian::Translation).should be_true
  end

  it 'should have a valid factory' do
    Factory(:translation).should be_valid
  end

  describe 'fields' do
    it { should have_field(:key, :datum).of_type(String) }
    it { should have_field(:language).of_type(Symbol) }
  end
end

