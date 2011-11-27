require 'malt/formats/abstract'

module Malt::Format

  #
  class PDF < Abstract

    file_extension 'pdf'

    #
    def pdf(*)
      text
    end

    #
    def to_pdf(*)
      self
    end

  end

end

