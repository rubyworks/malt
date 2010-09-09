require 'malt/formats/abstract'
require 'malt/formats/html'

module Malt::Formats

  # = YAML format
  #
  # TODO: hmm... maybe use data to update yaml?
  class YAML < Abstract

    register 'yaml', 'yml'

    #
    def yaml(*)
      text
    end

    alias_method :yml, :yaml

    #
    def to_yaml(*)
      self
    end

    alias_method :to_yml, :to_yaml

    # Converting a plan YAML file to HTML makes no sense so we
    # just wrap it in +pre+ tags.
    def html
      "<pre>\n#{h text}\n</pre>"
    end

    #
    def to_html
      text = html
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    private

      # TODO: HTML escaping
      def h(text)
        text
      end

  end

end

