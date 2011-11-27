require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/radius'

module Malt::Format

  # Radius Template
  #
  #   http://github.com/jlong/radius/
  #
  class Radius < Abstract

    register('radius')

    #
    def radius(*)
      text
    end

    #
    def to_radius(*)
      self
    end

    #
    def html(*data, &content)
      render_into(:html, *data, &content)
      #render_engine.render(:text=>text, :file=>file, :data=>data, &yld)
    end

    #
    def to_html(*data, &content)
      text = html(*data, &content)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engine::Radius.new(options)
      end

  end

end

