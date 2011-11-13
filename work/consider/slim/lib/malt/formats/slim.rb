require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/slim'

module Malt::Format

  # Slim looks like a Markup format, but it turns out to be
  # a template format too.
  class Slim < Abstract

    register 'slim'

    #
    def slim(*)
      text
    end

    #
    def to_slim(*)
      self
    end

    #
    def html(*data, &yld)
      render_engine.render(
        :format => :html,
        :text   => text,
        :file   => file,
        :data   => data,
        &yld
      )
    end

    #
    def to_html(*data, &yld)
      text = html(*data, &yld)
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

    private

      #
      def render_engine
        @render_engine ||= Malt::Engine::Smil.new(options)
      end

  end

end
