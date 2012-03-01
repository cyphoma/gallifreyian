# encoding: utf-8
module Gallifreyian
  module Translation
    class I18nKey
      include Mongoid::Document
      include Mongoid::Translation

      # Field
      #
      field :state,       type: Symbol, default: :validation_pending

      # Validations
      #
      validates :language, presence: true
      validate  :valid_datum?

      def validate
        self.state = :valid
      end

      def validate!
        validate
        self.i18n_key.save
      end

      def validation_pending?
        self.state == :validation_pending
      end

      private

      def valid_datum?
        unless self.datum.nil? || self.datum.is_a?(String)
          errors.add(:datum, :not_a_string)
        end
      end
    end
  end
end
