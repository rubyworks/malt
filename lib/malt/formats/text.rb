require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/pdf'

module Malt::Formats

  # Plain text format. This is used when the output
  # format is indeterminate.
  class Text < Abstract

    register('txt')

    # Using #to_html in text doesn't actually transform
    # the source text in any way. Rather it simply "informs"
    # Malt to treat the text as HTML.
    #
    # Returns an HTML object.
    def to_html
      HTML.new(:text=>text,:file=>refile('.html'))
    end

    # Using #to_pdf in text doesn't actually transform
    # the source text in any way. Rather it simply "informs"
    # Malt to treat the text as PDF.
    #
    # Returns a PDF object.
    def to_pdf
      PDF.new(:text=>text,:file=>refile('.pdf'))
    end

  end

end

