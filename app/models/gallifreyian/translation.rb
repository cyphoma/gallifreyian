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

end
