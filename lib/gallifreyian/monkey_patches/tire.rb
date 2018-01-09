require 'cgi'

module Tire
  module Model
    module Naming

      module ClassMethods

        def document_type name=nil
          @document_type = name if name
          @document_type || klass.model_name.to_s.underscore.singularize
        end

      end
    end
  end

  class Index
    def get_type_from_document(document)
      old_verbose, $VERBOSE = $VERBOSE, nil # Silence Object#type deprecation warnings
      type = case
        when document.respond_to?(:document_type)
          document.document_type
        when document.is_a?(Hash)
          document[:_type] || document['_type'] || document[:type] || document['type']
        when document.respond_to?(:_type)
          document._type
        when document.respond_to?(:type) && document.type != document.class
          document.type
        end
      $VERBOSE = old_verbose
      type ? CGI.escape(type)  :document
    end
  end

  module Search
    class Search

      def initialize(indices=nil, options = {}, &block)
        @indices = Array(indices)
        @types   = Array(options.delete(:type)).map { |type| CGI.escape(type) }
        @options = options

        @url     = Configuration.url+['/', @indices.join(','), @types.join(','), '_search'].compact.join('/').squeeze('/')

        block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
      end
    end
  end
end

