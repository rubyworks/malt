require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/rtals'

module Malt::Format

  #
  class Rtals < Abstract

    register('rtal')

    #
    def html(data=nil, &yld)
      render_engine.render(:text=>text, :data=>data, &yld)
    end

    #
    def to_html(data=nil, &yld)
      text = html(data, &yld)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    def xml(data=nil, &yld)
      render_engine.render(:text=>text, :data=>data, &yld)
    end

    #
    def to_xml(data=nil, &yld)
      text = xml(data, &yld)
      opts = options.merge(:text=>text, :file=>refile(:xml), :type=>:xml)
      HTML.new(opts)
    end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engine::RTALS.new(options)
      end

  end

end

