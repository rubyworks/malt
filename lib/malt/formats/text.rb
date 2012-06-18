require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/pdf'

module Malt::Format

  # Plain text format. Plain text documents are unique in that they can
  # be transformed into any other type of document. For example, applying
  # #to_html in text doesn't actually transform the source text in any way.
  # Rather it simply "informs" Malt to treat the text as HTML.
  #
  class Text < Abstract

    file_extension 'txt'

    #
    def txt(*)
      text
    end

    #
    def to_txt(*)
      self
    end

    #
    def method_missing(sym, *args, &block)
      if md = /^to_/.match(sym.to_s)
        type = md.post_match.to_sym
        opts = options.merge(:type=>type, :file=>refile(type))
        return Malt.text(text, opts)
      end
      super(sym, *args, &block)
    end

    # Returns an HTML object.
    #def to_html
    #  HTML.new(:text=>text,:file=>refile(:html))
    #end

    # Returns a PDF object.
    #def to_pdf
    #  PDF.new(:text=>text,:file=>refile(:pdf))
    #end

    private

      def render_engine
      end

  end

end

