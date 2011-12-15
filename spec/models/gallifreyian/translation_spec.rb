# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Translation do

  it 'should have a valid factory' do
    Factory(:translation).should be_valid
  end

  describe 'fields' do
    it { should have_field(:datum) }
    it { should have_field(:key).of_type(String) }
    it { should have_field(:language).of_type(Symbol) }
  end

  describe 'validations' do
    it { should validate_presence_of(:language) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }

    it "should not be valid" do
      Factory.build(:translation, datum: ['test']).should_not be_valid
    end
  end
end
