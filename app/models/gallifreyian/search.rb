# encoding: utf-8
module Gallifreyian
  class Search
    extend ActiveModel::Naming
    include ActiveSupport::Callbacks

    # Callbacks
    #
    define_callbacks :initialize
    set_callback :initialize, :after, :clean_params

    # Accessors
    #
    attr_accessor :query, :section, :state, :done, :languages,
      :page, :per_page, :validation_pending_languages, :done_languages

    def initialize(attributes = {})
      run_callbacks :initialize do
        attributes.each do |key, value|
          self.send("#{key}=", value) if self.respond_to?(:"#{key}=")
        end
      end
    end

    def to_key
    end

    private

    def clean_params
      case state
      when 'validation_pending'
        self.validation_pending_languages = Array(self.languages).reject(&:blank?) - Array(Gallifreyian::Configuration.main_language)
      when 'valid'
        self.validation_pending_languages = []
      end
      if self.done.to_s.present?
        self.done_languages = Array(self.languages).reject(&:blank?) - Array(Gallifreyian::Configuration.main_language)
      end
      self.languages = [self.languages] unless self.languages.kind_of?(Array)
      self.languages.reject!(&:blank?) if self.languages.present?
    end
  end
end
