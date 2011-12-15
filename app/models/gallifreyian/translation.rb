# encoding: utf-8
require 'sanitize'

class Gallifreyian::Translation
  include Mongoid::Document

  # Fields
  #
  field :language,    type: Symbol
  field :key,         type: String
  field :datum

  # Validations
  #
  validates :language, presence: true
  validates :key, presence: true, uniqueness: true
  validate  :valid_datum?

  # Callbacks
  #
  before_save :sanitize

  private

  def valid_datum?
    unless self.datum.is_a?(String)
      errors.add(:datum, :not_a_string)
    end
  end

  def sanitize
    self.datum = Sanitize.clean(self.datum)
  end
end
