require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/formats/xml'
require 'malt/engines/ragtag'

module Malt::Format

  # RagTag
  #
  #  http://github.com/rubyworks/ragtag
  #
  class RagTag < Abstract

    register('ragtag', 'rt')

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
      XML.new(opts)
    end

    private

      #
      def render_engine
        @render_engine ||= Malt::Engine::RagTag.new(options)
      end

  end

end

