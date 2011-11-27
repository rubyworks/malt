require 'malt/formats/abstract'

module Malt::Format

  #
  class HTML < Abstract

    file_extension 'html'  #, 'xhtml' ?

    #
    def html(*)
      text
    end

    # HTML is HTML ;)
    def to_html(*)
      self
    end

  end

end

