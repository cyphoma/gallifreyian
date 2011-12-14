# encoding: utf-8
class Gallifreyian::Translation
  include Mongoid::Document

  # Fields
  #
  field :language,    type: Symbol
  field :key,         type: String
  field :datum,       type: String

  # Validations
  #
  validates :language, presence: true
  validates :key, presence: true, uniqueness: true
end
