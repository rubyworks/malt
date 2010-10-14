require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/builder'

module Malt::Format

  # Builder looks like a Markup format, but it is a template format
  # as Ruby code.
  #
  #   http://builder.rubyforge.org/
  #
  class Builder < Abstract

    register 'builder'

    #
    def builder(*)
      text
    end

    #
    def to_builder(*)
      self
    end

    #
    def html(data=nil, &yld)
      render_engine.render(:format=>:html, :text=>text, :file=>file, :data=>data, &yld)
    end

    #
    def to_html(data=nil, &yld)
      text = html(data, &yld)
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
        @render_engine ||= Malt::Engine::Builder.new(options)
      end

  end

end

