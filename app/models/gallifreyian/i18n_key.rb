# encoding: utf-8
require 'sanitize'

class Gallifreyian::I18nKey
  include Mongoid::Document
  include Mongoid::Translate
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # Fields
  #
  field :key,         type: String
  field :section,     type: String

  # Translated fields
  #
  translate :datum

  # Validations
  #
  validates :key,      presence: true, uniqueness: true
  validates_associated :translations

  # Callbacks
  #
  before_save :sanitize, :set_section
  after_save :to_i18n, :missing_languages

  # Tire mapping
  #
  mapping do
    indexes :_id,               type: 'string', index: 'not_analyzed'
    indexes :key,               type: 'string'
    indexes :section,           type: 'string', index: 'not_analyzed'
    indexes :translations,      type: 'nested', include_in_parent: true do
      indexes :language,          type: 'string', index: 'not_analyzed'
      indexes :datum,             type: 'string', boost: 100
    end
  end

  def to_indexed_json
    {
      _id: self.id.to_s,
      translations: self.translations,
      key: self.key,
      section: self.section
    }.to_json
  end

  class << self
    def search(params = {})
      tire.search do
        params[:query].blank? ?
          query { all } :
          query { string params[:query] }
          filter :term, section: params[:section] if params[:section]
      end
    end
  end

  private

  def set_section
    sections = key.split('.')
    if sections.size > 1
      self.section = sections.first
    else
      self.section = 'global'
    end
  end

  def valid_datum?
    unless self.datum.is_a?(String)
      errors.add(:datum, :not_a_string)
    end
  end

  def sanitize
    self.translations.each do |translation|
      translation.datum = Sanitize.clean(translation.datum)
    end
    self.key = Sanitize.clean(self.key).parameterize('.')
  end

  def to_i18n
    Gallifreyian::Store.save(self)
  end

  def missing_languages
    languages = I18n.available_locales - self.translations.map(&:language)
    if languages.any?
      languages.each do |lang|
        self.translations.create(language: lang)
      end
    end
  end

end
