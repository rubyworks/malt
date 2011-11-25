require 'malt/engines/abstract'

module Malt::Engine

  # Nokogiri builder-like templates.
  #
  # @see http://nokogiri.org/

  class Nokogiri < Abstract

    default  :nokogiri
    register :rbml, :builder

    #
    DOCUMENT_HEADER_XML = /^<\?xml version=\"1\.0\"\?>\n?/

    #
    DOCUMENT_HEADER_HTML = /^<\!DOCTYPE html PUBLIC \".*?\">/

    #
    def render(params, &content)
      into = parameters(params, :to) || :html

      case into.to_sym
      when :html
        prepare_engine(params, &content).to_html.sub(DOCUMENT_HEADER_HTML,'')
      when :xml, :xhtml
        prepare_engine(params, &content).to_xml.sub(DOCUMENT_HEADER_XML,'')
      else
        super(params, &content)
      end
    end

    #
    def prepare_engine(params={}, &content)
      text, file, data = parameters(params, :text, :file, :data)

      scope, locals = external_scope_and_locals(data, &content)

      engine = create_engine(params)

      locals.each do |k,v|
        engine.instance_eval("@#{k} = v")
      end

      scope.instance_variables.each do |k|
        next if k == "@target"
        v = scope.instance_variable_get(k)
        engine.instance_eval("#{k} = v")    
      end

      engine.instance_eval(text, file || inspect)

      engine
    end

    # Nokogiri engine cannot be cached as it keeps a copy the
    # rendering internally. (Unless there is a way to clear it?)
    #
    def create_engine(params={})
      into = parameters(params, :to) || :html

      opts = engine_options(params)

      #cached(into, opts) do
        case into
        when :html
          ::Nokogiri::HTML::Builder.new(opts)
        else
          ::Nokogiri::XML::Builder.new(opts)
        end
      #end
    end

  private

    # Load Nokogiri library if not already loaded.
    def require_engine
      return if defined? ::Nokogiri
      require_library 'nokogiri'

      ::Nokogiri::XML::Builder.class_eval do
        undef_method :p
      end
    end

  end

end
