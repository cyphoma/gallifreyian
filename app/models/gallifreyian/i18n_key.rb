# encoding: utf-8
require 'sanitize'

class Gallifreyian::I18nKey
  include Mongoid::Document
  include Mongoid::Translate
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # Constants
  STATES = ['validation_pending', 'valid']

  # Fields
  #
  field :key,         type: String
  field :section,     type: String
  field :done,        type: Boolean

  # Translated fields
  #
  translate :datum

  # Validations
  #
  validates :key,      presence: true, uniqueness: true
  validates_associated :translations

  # Callbacks
  #
  before_save :set_state, :sanitize, :set_done, :set_section
  after_save :to_i18n, :js_locales

  # ES mapping
  #
  index_name Gallifreyian::Configuration.index_name || 'gallifreyian'
  settings analysis: {
    analyzer: {
      key_path: {
        type: 'pattern',
        pattern: '[.]'
      }
    }
  }

  mapping do
    indexes :_id,               type: :string, index: :not_analyzed
    indexes :key,               type: :string, analyzer: :key_path, boost: 50
    indexes :keys,              type: :string, analyzer: :keyword, boost: 50
    indexes :section,           type: :string, index: :not_analyzed
    indexes :state,             type: :string, index: :not_analyzed
    indexes :done,              type: :boolean, index: :not_analyzed
    indexes :validation_pending_languages,  type: :string,  index_name: :validation_pending_language, index: :not_analyzed
    indexes :undone_languages,  type: :string,  index_name: :undone_language, index: :not_analyzed
    indexes :done_languages,  type: :string,  index_name: :done_language, index: :not_analyzed

    indexes :translations,      type: :nested, include_in_parent: true do
      indexes :language,          type: :string, index: :not_analyzed
      indexes :datum,             type: :string, boost: 100
      indexes :pretty,            type: :string, boost: 50
    end
  end

  def state
    self.translations.reject {|t| t.datum.blank? }.any? {|translation| translation.state == :validation_pending } ? :validation_pending : :valid
  end

  def as_indexed_json(options = {})
    {
      _id: self.id.to_s,
      translations: self.translations,
      key: self.key,
      keys: self.key.split('.'), #FIXME elastic search should that with key
      section: self.section,
      state: self.state,
      done: self.done,
      undone_languages: self.undone_languages,
      pretty: self.pretty,
      validation_pending_languages: self.validation_pending_languages,
      done_languages: self.done_languages
    }
  end

  def pretty
    self.key.split('.').last.humanize
  end

  # User Gallifreyian::Configuration.available_locales to add missing translations on this I18nKey
  #
  # @return [Array]     of Gallifreyian::Translation::I18nKey
  #
  def available_translations
    missing_locales = Gallifreyian::Configuration.available_locales - translations.map(&:language)
    missing_locales.each do |locale|
      self.translations << Gallifreyian::Translation::I18nKey.new(language: locale)
    end
    self.translations.order_by({:language => :asc})
  end

  def validate
    self.translations.each do |translation|
      translation.state = :valid
    end
  end

  def validation_pending_languages
    translations.where(state: :validation_pending).all.map(&:language)
  end

  def done_languages
    translations.not_in(datum: [nil, '']).all.map(&:language)
  end

  def undone_languages
    Gallifreyian::Configuration.available_locales - done_languages
  end

  def validate!
    validate
    save
  end

  class << self
    def search(params = Gallifreyian::Search.new)
      definition = params.to_search_definition
      puts definition.to_json

      __elasticsearch__.search(definition)
    end
  end

  def populate_translations
    Array(Gallifreyian::Configuration.available_locales - self.languages).each do |loc|
      self.translations.build(language: loc, datum: '')
    end
  end

  private

  # Update js locales
  #
  def js_locales
    if Gallifreyian::Configuration.js_locales && self.section == 'js'
      Gallifreyian::JsonExporter.run
    end
  end

  def set_state
    translation = self.translations.where(language: Gallifreyian::Configuration.main_language).one
    if translation && translation.datum_changed?
      translations.each do |t|
        t.state = :validation_pending
      end
      translation.state = :valid
    end
    translation.state = :valid if translation
  end

  def set_section
    sections = key.split('.')
    if sections.size > 1
      self.section = sections.first
    else
      self.section = 'global'
    end
  end

  def set_done
    self.done = self.translations.all? { |translation| translation.datum.present? } && Array(Gallifreyian::Configuration.available_locales - self.languages).empty?
    return
  end

  def valid_datum?
    unless self.datum.is_a?(String)
      errors.add(:datum, :not_a_string)
    end
  end

  def sanitize
    self.key = CGI.unescapeHTML(Sanitize.clean(self.key))
  end

  def to_i18n
    Gallifreyian::Store.save(self)
  end

end
