require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/pdf'

module Malt::Formats

  # Plain text format. This is used when the output
  # format is indeterminate.
  class Text < Abstract

    register('txt')

    #
    def txt
      text
    end

    #
    def to_txt
      self
    end

    #
    def method_missing(sym, *args, &block)
      if md = /^to_/.match(sym.to_s)
        opts = options.merge(:type=>md.post_match)
        return Malt.text(text, opts)
      end
      super(sym, *args, &block)
    end

    # Using #to_html in text doesn't actually transform
    # the source text in any way. Rather it simply "informs"
    # Malt to treat the text as HTML.
    #
    # Returns an HTML object.
    #def html
    #  HTML.new(:text=>text,:file=>refile('.html'))
    #end

    # Using #to_pdf in text doesn't actually transform
    # the source text in any way. Rather it simply "informs"
    # Malt to treat the text as PDF.
    #
    # Returns a PDF object.
    #def pdf
    #  PDF.new(:text=>text,:file=>refile('.pdf'))
    #end

    private

      def render_engine
      end

  end

end

