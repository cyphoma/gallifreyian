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

  # Translated fields
  #
  translate :datum

  # Validations
  #
  validates :key,      presence: true, uniqueness: true
  validates_associated :translations

  # Callbacks
  #
  before_save :sanitize
  after_save :to_i18n, :missing_languages

  # Tire mapping
  #
 # mapping do
 #   indexes :_id,               type: 'string', index: 'not_analyzed'
 #   indexes :language,          type: 'string', index: 'not_analyzed'
 #   indexes :datum,             type: 'string', boost: 100
 #   indexes :key,               type: 'string'
 #   indexes :full_key,          type: 'string'
 # end

  def to_indexed_json
    self.to_json
  end

  private

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
        self.translations << Gallifreyian::Translation::I18nKey.new(language: lang)
      end
      self.save
    end
  end

end
