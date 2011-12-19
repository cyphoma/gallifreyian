# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Store do
  before do
    i18n = Gallifreyian::I18nKey.new(key: "plop.nested")
    i18n.translations << Gallifreyian::Translation::I18nKey.new(datum: "This is a nested en test", language: :en)
    i18n.translations << Gallifreyian::Translation::I18nKey.new(datum: "テストなんです", language: :ja)
    i18n.save
  end

  it 'should return translation for en' do
    I18n.t('plop.nested').should eq 'This is a nested en test'
  end

  it 'should return translation for ja' do
    I18n.locale = :ja
    I18n.t('plop.nested').should eq 'テストなんです'
    I18n.locale = :en
  end
end
