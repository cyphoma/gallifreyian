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
      :page, :per_page, :validation_pending_languages, :done_languages,
      :undone_languages

    def initialize(attributes = {})
      run_callbacks :initialize do
        attributes.each do |key, value|
          self.send("#{key}=", value) if self.respond_to?(:"#{key}=")
        end
      end
    end

    def to_key
    end

    def to_search_definition
      size = per_page.present? ? per_page : 10
      from = ((page||1).to_i-1)*size.to_i

      Elasticsearch::DSL::Search.search do |s|
        s.query do |s|
          s.bool do |s|
            s.must do |s|
              if query.blank?
                s.match_all {}
              else
                s.query_string {|s| s.query query.gsub('.', ' ') }
              end
            end

            s.filter do |s|
              s.term(section: section)                            if section.present?
              s.term(state: state)                                if state.present? && state == 'valid'
              s.term(done: done)                                  if done.try(:to_s).present? && done_languages.blank? && done.to_s == 'true'
              s.terms('translations.language' => languages)       if languages.present?
              s.terms(undone_languages: undone_languages)         if undone_languages.present?
              s.terms(validation_pending_languages: params.validation_pending_languages) if validation_pending_languages.present?
              if done_languages.present? && done_languages.is_a?(Array)
                done_languages.each do |lang|
                  s.terms(done_languages: Array(lang))
                end
              end
            end
          end
        end

        # facet 'sections' do
        #   terms :section
        # end

        s.size size
        s.from from
      end
    end

    private

    def clean_params
      case state
      when 'validation_pending'
        self.validation_pending_languages = Array(self.languages).reject(&:blank?) - Array(Gallifreyian::Configuration.main_language)
      when 'valid'
        self.validation_pending_languages = []
      end
      if self.done.to_s.present? && self.done.to_s == 'true'
        self.done_languages = Array(self.languages).reject(&:blank?) - Array(Gallifreyian::Configuration.main_language)
      elsif self.done.to_s.present? && self.done.to_s == 'false'
        self.undone_languages = Array(self.languages).reject(&:blank?) - Array(Gallifreyian::Configuration.main_language)
      end
      self.languages = [self.languages] unless self.languages.kind_of?(Array)
      self.languages.reject!(&:blank?) if self.languages.present?
    end

  end
end
