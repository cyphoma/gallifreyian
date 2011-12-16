# encoding: utf-8
require 'sanitize'

class Gallifreyian::Translation
  include Mongoid::Document

  # Fields
  #
  field :language,    type: Symbol
  field :full_key,    type: String
  field :key,         type: String
  field :datum

  # Validations
  #
  validates :language, presence: true
  validates :full_key, presence: true, uniqueness: true
  validates :key,      presence: true
  validate  :valid_datum?

  # Callbacks
  #
  before_validation :sync_keys
  before_save :sanitize
  # TODO: fix observer
  after_save :to_i18n

  # Scopes
  #
  scope :by_language, lambda {|lang| where(language: lang)}
  scope :siblings,    lambda {|key|  where(key:      key)}

  def siblings
    self.class.siblings(self.key)
  end

  private

  def sync_keys
    if key.present?
      self.full_key = "#{language}.#{key}"
    elsif full_key.present?
      start = language.length + 1
      self.key = full_key.slice(start..-1)
    end
  end

  def valid_datum?
    unless self.datum.is_a?(String)
      errors.add(:datum, :not_a_string)
    end
  end

  def sanitize
    self.datum = Sanitize.clean(self.datum)
    self.key = Sanitize.clean(self.key).parameterize('.')
  end

  def to_i18n
    Gallifreyian::Store.save(self)
  end

end
