require 'malt/formats/abstract'
require 'malt/engines/less'

module Malt::Format

  # = LESS
  #
  # See http://lesscss.org/
  #
  class LESS < Abstract

    register('less')

    #
    def less(*)
      text
    end

    #
    def to_less(*)
      self
    end

    #
    def css(*)
      render_engine.render(:text=>text, :file=>:file, :format=>:css)
    end

    #
    def to_css(*)
      text = css
      opts = options.merge(:text=>text, :file=>refile(:css), :type=>:css)
      CSS.new(opts)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engine::Less.new(options)
    end

    # LESS default output type is CSS.
    def default
      :css
    end

  end

end

