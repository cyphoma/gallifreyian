# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Translation do

  it 'should have a valid factory' do
    Factory(:translation).should be_valid
  end

  describe 'fields' do
    it { should have_field(:key, :datum).of_type(String) }
    it { should have_field(:language).of_type(Symbol) }
  end

  describe 'validations' do
    it { should validate_presence_of(:language) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
  end
end
