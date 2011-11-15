require 'malt/engines/abstract'

module Malt::Engine

  # Nokogiri builder-like templates.
  #
  # @see http://nokogiri.org/

  class Nokogiri < Abstract

    #
    DOCUMENT_HEADER = /^<\?xml version=\"1\.0\"\?>\n?/

    # TODO: "htmlify" the xml for :to=>:html

    #
    def render(params, &yld)
      into = params[:to]

      case into
      when :xml, :xhtml, nil
        render_xml(params, &yld)
      when :html
        render_xml(params, &yld)
      else
        super(params, &yld)
      end
    end

    #
    def render_xml(params, &yld)
      text = params[:text]
      data = params[:data]

      scope, locals = make_scope_and_data(data)

      xml = intermediate(params).to_xml

      xml.sub(DOCUMENT_HEADER, "")
    end

    # Convert to intermediate object.
    #
    # @todo: Possible to allow `yield` in dsl?
    def intermediate(params, &yld)
      text = params[:text]
      if text.respond_to?(:to_str)
        builder = ::Nokogiri::XML::Builder.new
        builder.instance_eval(text)
        builder
      else
        ::Nokogiri::XML::Builder.new.tap(&text)
      end
    end

    private

    # Load Nokogiri library if not already loaded.
    def initialize_engine
      return if defined? ::Nokogiri
      require_library 'nokogiri'
    end

  end

end
