# encoding: UTF-8
require 'spec_helper'

describe Gallifreyian::Configuration do

  context 'helpers' do
    context 'empty option' do
      let!(:configuration) {
        Gallifreyian::Configuration.configure do |config|
          config.helpers = nil
        end
      }

      it 'should return I18n available_locales' do
        Gallifreyian::Configuration.helpers.should eq([])
      end
    end

    context 'with option' do
      let!(:configuration) {
        Gallifreyian::Configuration.configure do |config|
          config.helpers = [:config]
        end
      }

      it 'should return I18n available_locales' do
        Gallifreyian::Configuration.helpers.should eq([:config])
      end
    end
  end

  context 'available_locales' do
    context 'empty option' do
      let!(:configuration) {
        Gallifreyian::Configuration.configure do |config|
          config.available_locales = []
        end
      }

      it 'should return I18n available_locales' do
        Gallifreyian::Configuration.available_locales.should_not be_blank
        Gallifreyian::Configuration.available_locales.should eq(I18n.available_locales)
      end
    end

    context 'with something' do
      let(:locales) {[:fr, :en]}
      let!(:configuration) {
        Gallifreyian::Configuration.configure do |config|
          config.available_locales = locales
        end
      }

      it 'should return I18n available_locales' do
        Gallifreyian::Configuration.available_locales.should_not be_blank
        Gallifreyian::Configuration.available_locales.should eq(locales)
      end
    end
  end
end
