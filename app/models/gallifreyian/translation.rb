# encoding: utf-8
class Gallifreyian::Translation
  include Mongoid::Document

  field :language,    type: Symbol
  field :key,         type: String
  field :datum,       type: String
end
