require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erector'

module Malt::Format

  # Erecotr looks like a Markup format, but it is a template format
  # Much like pure Ruby too.
  class Erector < Abstract

    register 'erector'

    #
    def erector(*)
      text
    end

    #
    def to_erector(*)
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
        @render_engine ||= Malt::Engine::Erector.new(options)
      end

  end

end

