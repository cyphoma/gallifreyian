# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Store do
  before do
    Gallifreyian::I18nKey.create(key: "en.plop.nested", datum: "This is a nested en test", language: :en)
    Gallifreyian::I18nKey.create(key: "ja.plop.nested", datum: "テストなんです", language: :ja)
  end

  it 'should return translation for en' do
    I18n.t('en.plop.nested').should eq 'This is a nested en test'
  end

  it 'should return translation for ja' do
    I18n.locale = :ja
    I18n.t('ja.plop.nested').should eq 'テストなんです'
    I18n.locale = :en
  end
end
