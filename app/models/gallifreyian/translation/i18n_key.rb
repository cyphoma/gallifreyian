# encoding: utf-8
module Gallifreyian
  module Translation
    class I18nKey
      include Mongoid::Document
      include Mongoid::Translation

      # Validations
      #
      validates :language, presence: true
      validate  :valid_datum?

      private

      def valid_datum?
        unless self.datum.is_a?(String)
          errors.add(:datum, :not_a_string)
        end
      end
    end
  end
end
