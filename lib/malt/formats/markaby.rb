require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/markaby'

module Malt::Format

  # Erecotr looks like a Markup format, but it is a template format
  # Much like pure Ruby too.
  class Markaby < Abstract

    register 'markaby', 'mab'

    #
    def markaby(*)
      text
    end

    #
    def to_markaby(*)
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
        @render_engine ||= Malt::Engine::Markaby.new(options)
      end

  end

end

