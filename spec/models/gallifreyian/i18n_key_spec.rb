# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::I18nKey do
  let(:i18n) { Factory :i18n }
  let(:translation) { Factory.build :translation }

  it 'should have a valid factory' do
    Factory(:i18n).should be_valid
  end

  describe 'fields' do
    it { should have_field(:key).of_type(String) }
  end

  describe 'validations' do
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }

    it "should not be valid" do
      f = Factory.build(:i18n)
      f.translations << Gallifreyian::Translation::I18nKey.new(datum: ['test'])
      f.should_not be_valid
    end
  end

  describe 'callbacks' do
    it 'should sanitize datum' do
      translation.datum = '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg">'
      i18n.translations << translation
      i18n.save
      i18n.translations.last.datum.should eq 'foo'
    end

    it 'should sanitize key' do
      i18n.key = 'fr.clé .test'
      i18n.save
      i18n.key.should eq 'fr.cle.test'
      i18n.key = 'fr.clé .<p>testé</p>'
      i18n.save
      i18n.key.should eq 'fr.cle.teste'
    end

    it 'should create keys for missing languages' do
      i18n = Factory.build :i18n
      i18n.translations.size.should eq 1
      i18n.save
      i18n.reload.translations.size.should > 1
    end
  end


  describe 'search' do
    describe 'full text search' do
      before do
        i18n
        Gallifreyian::I18nKey.tire.index.refresh
      end

      context 'no pattern is givent' do
        it 'should have results' do
          results = Gallifreyian::I18nKey.search.results
          results.size.should eq 1
        end
      end

      context 'bad pattern is given' do
        it 'should not have results' do
          results = Gallifreyian::I18nKey.search(query: 'bogus').results
          results.should_not be_any
        end
      end

      context 'good pattern is given' do
        it 'should have results' do
          pattern = i18n.translations.first.datum.split.first
          results = Gallifreyian::I18nKey.search(query: pattern).results
          results.size.should eq 1
        end
      end
    end
  end
end
