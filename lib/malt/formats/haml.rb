require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/haml'

module Malt::Format

  # Haml looks like a Markup format, but it turns out to be
  # a template format too.
  class Haml < Abstract

    register 'haml'

    #
    def haml(*)
      text
    end

    #
    def to_haml(*)
      self
    end

    #
    def html(*data, &content)
      render_into(:html, *data, &content)
    end

    #
    def to_html(*data, &content)
      text = html(*data, &content)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    #def to_ruby(db, &yld)
    #  @ruby ||= (
    #    source = engine.compile(text, file)
    #    Ruby.new(:text=>source, :file=>refile(:rb))
    #  )
    #end

    #private

      #
      #def render_engine
      #  @render_engine ||= Malt::Engine::Haml.new(options)
      #end

  end

end

