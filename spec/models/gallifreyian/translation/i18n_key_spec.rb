# encoding: utf-8
require 'spec_helper'

describe Gallifreyian::Translation::I18nKey do

  describe 'fields' do
    it { should have_field(:datum) }
    it { should have_field(:language).of_type(Symbol) }
  end

  describe 'validations' do
    it { should validate_presence_of(:language) }
  end

end
