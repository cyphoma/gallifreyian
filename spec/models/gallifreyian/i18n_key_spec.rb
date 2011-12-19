# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::I18nKey do
  let(:translation) { Factory :translation }

  it 'should have a valid factory' do
    Factory(:translation).should be_valid
  end

  describe 'fields' do
    it { should have_field(:datum) }
    it { should have_field(:key).of_type(String) }
    it { should have_field(:full_key).of_type(String) }
    it { should have_field(:language).of_type(Symbol) }
  end

  describe 'validations' do
    it { should validate_presence_of(:language) }
    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:full_key) }
    it { should validate_uniqueness_of(:full_key) }

    it "should not be valid" do
      Factory.build(:translation, datum: ['test']).should_not be_valid
    end
  end

  describe 'callbacks' do
    it 'should build full_key from key and language' do
      translation = Factory.build(:translation, language: :en, key: 'clef', datum: 'something')
      translation.full_key.should be_nil
      translation.save
      translation.full_key.should eq "#{translation.language}.#{translation.key}"
    end

    it 'should sanitize datum' do
      translation.datum = '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg">'
      translation.save
      translation.datum.should eq 'foo'
    end

    it 'should sanitize key' do
      translation.key = 'fr.clé .test'
      translation.save
      translation.key.should eq 'fr.cle.test'
      translation.key = 'fr.clé .<p>testé</p>'
      translation.save
      translation.key.should eq 'fr.cle.teste'
    end
  end
end
