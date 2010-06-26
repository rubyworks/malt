require 'malt/formats/abstract'

module Malt::Formats

  #
  class YAML < Abstract

    register('yaml', 'yml')

    # TODO: hmm... maybe use db to update yaml?
    def yaml(*)
      self
    end

    #
    def render_to(to, db, &yld)
      case to
      when :yaml, :yml
        text  # TODO: This right, or +self+?
      when :html
        "<pre>#{h text}</pre>"
      else
        raise UnspportedConversion.new(type, to)
      end
    end

    ;;;; private ;;;;

    # TODO: HTML escaping.
    def h(text)
      text
    end

  end

end

