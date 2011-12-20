# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::I18nKey do
  let(:i18n) { Factory :i18n }
  let(:translation) { Factory.build :translation }
  let(:main_language) { Gallifreyian::Configuration.main_language }

  it 'should have a valid factory' do
    Factory(:i18n).should be_valid
  end

  describe 'fields' do
    it { should have_field(:key, :section).of_type(String) }
    it { should have_field(:done).of_type(Boolean) }
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
      i18n.translations.first.datum = '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg">'
      i18n.save
      i18n.translations.first.datum.should eq 'foo'
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

    describe 'sections' do
      it 'should persists a section based on key' do
        i18n.key = 'test.plop'
        i18n.save
        i18n.section.should eq 'test'
      end

      it 'should persists a section based on key' do
        i18n.key = 'test.plop.foo.bar'
        i18n.save
        i18n.section.should eq 'test'
      end

      it 'should be global by default' do
        i18n.key = 'test'
        i18n.save
        i18n.section.should eq 'global'
      end
    end

    describe 'state' do
      it 'should set i18n as :validation_pending' do
        translation = i18n.translations.where(language: main_language).one
        translation.datum = 'Nouvelle traduction'
        i18n.save
        i18n.state.should eq :validation_pending
        i18n.save
        i18n.state.should eq :valid
      end
    end

    describe 'done' do
      it 'should set done to true' do
        i18n.reload.translations.each do |translation|
          translation.datum = 'Content'
        end
        i18n.save
        i18n.reload.done?.should be_true
        i18n.translations.last.datum = ''
        i18n.save
        i18n.done?.should be_false
      end

      it 'should set done to false' do
        i18n = Gallifreyian::I18nKey.new(key: 'foo.bar.tardis')
        i18n.translations.build(language: :en, datum: '')
        i18n.save
        i18n.done.should be_false
      end
    end
  end


  describe 'search' do
    describe 'full text search' do
      before do
        i18n
        Gallifreyian::I18nKey.tire.index.refresh
      end

      context 'no pattern is given' do
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

    describe 'search with filters' do

      context 'with a filter on section' do
        before do
          i18n.key = 'test.plop'
          i18n.save
          i18n = Gallifreyian::I18nKey.create(key: 'foo.bar')
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it 'should have one result' do
          results = Gallifreyian::I18nKey.search(section: 'test').results
          results.size.should eq 1
        end

        it 'should have a facets on section' do
          facets = Gallifreyian::I18nKey.search(section: 'test').facets
          facets['sections']['terms'].should eq [{"term"=>"test", "count"=>1}, {"term"=>"foo", "count"=>1}]
        end

      end

      context 'with a filter on language (nested)' do
        before do
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar')
          i18n.translations.build(language: :fr, datum: 'On veut trouver.')
          i18n.save
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar.tardis')
          i18n.translations.build(language: :en, datum: 'On veut trouver.')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it "should have a total of 2 results" do
          results = Gallifreyian::I18nKey.search.results
          results.size.should eq 2
        end

        it 'should find based on language (french)' do
          results = Gallifreyian::I18nKey.search(languages: ['fr']).results
          results.size.should eq 1
        end

        it 'should find based on language (english)' do
          results = Gallifreyian::I18nKey.search(languages: ['en']).results
          results.size.should eq 1
        end

        it "should have a total of 2 results" do
          results = Gallifreyian::I18nKey.search(languages: ['fr', 'en']).results
          results.size.should eq 2
        end

        it 'should wrapping up' do
          results = Gallifreyian::I18nKey.search({
            query: 'veut', section: 'foo', language: 'en', state: 'validation_pending'
          }).results
          results.size.should eq 1
        end
      end

      context 'with a filter on state' do
        before do
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar')
          i18n.translations.build(language: :fr, datum: 'On veut trouver.')
          i18n.save
          i18n.save
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar.tardis')
          i18n.translations.build(language: :en, datum: 'On veut trouver.')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it "should have a total of 2 results" do
          results = Gallifreyian::I18nKey.search.results
          results.size.should eq 2
        end

        it 'should find based on valid state' do
          results = Gallifreyian::I18nKey.search(state: 'valid').results
          results.size.should eq 1
        end

        it 'should find based on validation_pending' do
          results = Gallifreyian::I18nKey.search(state: 'validation_pending').results
          results.size.should eq 1
        end

      end

      context 'with a filter on done' do
        before do
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar')
          i18n.translations.build(language: :fr, datum: 'On veut trouver.')
          i18n.translations.each do |translation|
            translation.datum = 'Document traduit.'
          end
          i18n.save
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar.tardis')
          i18n.translations.build(language: :en, datum: '')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it "should have a total of 2 results" do
          results = Gallifreyian::I18nKey.search.results
          results.size.should eq 2
        end

        it 'should find completed translation' do
          results = Gallifreyian::I18nKey.search(done: true).results
          results.size.should eq 1
        end

        it 'should find uncompleted translation' do
          results = Gallifreyian::I18nKey.search(done: false).results
          results.size.should eq 1
        end

      end
    end

  end
end
