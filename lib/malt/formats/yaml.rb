require 'malt/formats/abstract'

module Malt::Formats

  # TODO: hmm... maybe use db to update yaml?
  class YAML < Abstract

    register('yaml', 'yml')

    #
    def yaml
      text
    end

    #
    def to_yaml
      self
    end

    # Converting a plan YAML file to HTML makes no sense so we
    # just wrap it in +pre+ tags.
    def html
      "<pre>\n#{h text}\n</pre>"
    end

    #
    def to_html
      opts = options.merge(:text=>html, :file=>refile(:html))
      HTML.new(opts)
    end

    #
    #def render_to(to, db, &yld)
    # case to
    #  when :yaml, :yml
    #    text  # TODO: This right, or +self+?
    #  when :html
    #    "<pre>#{h text}</pre>"
    #  else
    #    raise UnspportedConversion.new(type, to)
    #  end
    #end

    private

      # TODO: HTML escaping.
      def h(text)
        text
      end

  end

end

