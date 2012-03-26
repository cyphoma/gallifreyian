# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::I18nKey do
  let(:i18n) {
    Factory :i18n,
      translations: [translation]
  }
  let(:translation) {
    Factory.build :translation,
      language: Gallifreyian::Configuration.main_language
  }
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

  describe 'validate' do
    it 'should validate a key' do
      i18n.validate
      i18n.state.should eq :valid
    end

    it 'should validate a key and save' do
      i18n.validate!
      i18n.state.should eq :valid
      i18n.reload.state.should eq :valid
    end
  end

  describe 'callbacks' do
    it 'should sanitize datum' do
      i18n.translations.first.datum = '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg">'
      i18n.save
      i18n.translations.first.datum.should eq 'foo'
    end

    it 'should sanitize key' do
      i18n.key = 'fr.clé.test'
      i18n.save
      i18n.key.should eq 'fr.clé.test'
      i18n.key = 'fr.clé .<p>testé</p>'
      i18n.save
      i18n.key.should eq 'fr.clé . testé '
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
        i18n.translations << Gallifreyian::Translation::I18nKey.new(datum: 'test', language: :de)
        i18n.save
        translation = i18n.translations.first
        translation.datum = 'Nouvelle traduction'
        i18n.save
        i18n.state.should eq :validation_pending
        i18n.save
        i18n.state.should_not eq :valid
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

    describe 'js' do
      it 'should call JsonExporter when a js key is save' do
        Gallifreyian::JsonExporter.should_receive(:run).and_return(true)
        i18n.key = 'js.test'
        i18n.save
      end

      it 'should not call JsonExporter when a non js key is save' do
        Gallifreyian::JsonExporter.should_not_receive(:run).and_return(true)
        i18n.key = 'test'
        i18n.save
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
        let(:search_params) {Gallifreyian::Search.new(query: 'bogus')}

        it 'should not have results' do
          results = Gallifreyian::I18nKey.search(search_params).results
          results.should_not be_any
        end
      end

      context 'good pattern is given' do
        let(:search_params) {Gallifreyian::Search.new(query: i18n.translations.first.datum.split.first)}

        it 'should have results' do
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end
      end

      context 'prettyfy is given as pattern' do
        let(:i18n) do
          i18n = Gallifreyian::I18nKey.new(key: 'test.bar_foo')
          i18n.translations.build(language: :en, datum: 'hello')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it 'should have results' do
          search_params = Gallifreyian::Search.new(query: "Bar foo")
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end
      end

      context 'good pattern with a special char is given' do
        let(:i18n) do
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar')
          i18n.translations.build(language: :en, datum: 'hello')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        ["+", "-", "&&", "||", "!", "(", ")", "{", "}", "[", "]", "^",
        "\"", "~", "*", "?", ":", "\\"].each do |c|
          it 'should have results' do
            search_params = Gallifreyian::Search.new(query: "Hello#{c}")
            results = Gallifreyian::I18nKey.search(search_params).results
            results.size.should eq 1
          end
        end
      end

      context 'search in key and body' do
        let(:i18n) do
          i = Gallifreyian::I18nKey.new(
            key: "pim.pam.poum"
          )
          i.translations << Gallifreyian::Translation::I18nKey.new(
            language: :fr,
            datum: "Le capitaine et les deux garnements"
          )
          i.save
          Tire.index(Gallifreyian::I18nKey.index_name) do
            refresh
          end
          i
        end

        it 'should split the key' do
          pending "ES should split key on ."
          i18n
          t =  Tire.index(Gallifreyian::I18nKey.index_name)
          tokens = t.analyze("a.b.c", analyzer: 'key_path')
          tokens.map{|token| token.token}.should eq %w{a b c}
        end

        it 'should find by key' do
          #pending "Garbage in the index?"
          %w{ pim pam poum }.each do |q|
            params = Gallifreyian::Search.new(query: q)
            results = Gallifreyian::I18nKey.search(params).results
            results.size.should eq 1
          end
        end
        it 'should find by datum' do
          search_params = Gallifreyian::Search.new(query: 'capitaine')
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end
      end
    end

    describe 'search with filters' do

      context 'with a filter on section' do
        let(:search_params) {Gallifreyian::Search.new(section: 'test')}

        before do
          i18n.key = 'test.plop'
          i18n.save
          i18n = Gallifreyian::I18nKey.create(key: 'foo.bar')
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it 'should have one result' do
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it 'should have a facets on section' do
          facets = Gallifreyian::I18nKey.search(search_params).facets
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
          i18n.translations.build(language: :de, datum: 'On veut trouver.')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it "should have a total of 2 results" do
          results = Gallifreyian::I18nKey.search.results
          results.size.should eq 2
        end

        it 'should find based on language (french)' do
          search_params = Gallifreyian::Search.new(languages: ['fr'])
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it 'should find based on language (english)' do
          search_params = Gallifreyian::Search.new(languages: ['en'])
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it "should have a total of 2 results" do
          search_params = Gallifreyian::Search.new(languages: ['fr', 'en'])
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 2
        end

        it 'should wrapping up' do
          search_params = Gallifreyian::Search.new(
            query: 'veut', section: 'foo', languages: ['en'], state: 'validation_pending'
          )
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end
      end

      context 'with a filter on state' do
        before do
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar')
          i18n.translations.build(language: main_language, datum: 'On veut trouver.')
          i18n.translations.build(language: :de, datum: 'On veut trouver.')
          i18n.save
          i18n.validate!
          i18n = Gallifreyian::I18nKey.new(key: 'foo.bar.tardis')
          i18n.translations.build(language: main_language, datum: 'On veut trouver.')
          i18n.translations.build(language: :de, datum: 'On veut trouver.')
          i18n.save
          Gallifreyian::I18nKey.tire.index.refresh
        end

        it "should have a total of 2 results" do
          results = Gallifreyian::I18nKey.search.results
          results.size.should eq 2
        end

        it 'should find based on valid state' do
          search_params = Gallifreyian::Search.new(state: 'valid')
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it 'should find based on validation_pending' do
          search_params = Gallifreyian::Search.new(state: 'validation_pending')
          results = Gallifreyian::I18nKey.search(search_params).results
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

        it "should have a total of 2 results with a empty done" do
          search_params = Gallifreyian::Search.new(done: '')
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 2
        end

        it 'should find completed translation' do
          search_params = Gallifreyian::Search.new(done: true)
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it 'should find uncompleted translation' do
          search_params = Gallifreyian::Search.new(done: false)
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it 'should find completed translation, as string' do
          search_params = Gallifreyian::Search.new(done: 'true')
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

        it 'should find uncompleted translation, as string' do
          search_params = Gallifreyian::Search.new(done: 'false')
          results = Gallifreyian::I18nKey.search(search_params).results
          results.size.should eq 1
        end

      end
    end

  end

  describe 'available_translations' do

    it "should return a translation for each I18n.available_locales event if not present" do
      i18n.translations.count.should eq 1
      i18n.available_translations.each do |translation|
        translation.should be_kind_of(Gallifreyian::Translation::I18nKey)
      end
      i18n_locales = i18n.available_translations.map(&:language)
      I18n.available_locales.each do |locale|
        i18n_locales.should include(locale)
      end
    end

  end
end
