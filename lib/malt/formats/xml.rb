require 'malt/formats/abstract'

module Malt::Format

  # TODO: Add conversion to_html.
  class XML < Abstract

    register 'xml'

    #
    def xml(*)
      text
    end

    # XML is XML ;)
    def to_xml(*)
      self
    end

    private

    #
    def render_engine
    end

  end

end

