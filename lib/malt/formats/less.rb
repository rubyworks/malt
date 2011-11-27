require 'malt/formats/abstract'
require 'malt/engines/less'

module Malt::Format

  # = LESS
  #
  # See http://lesscss.org/
  #
  class LESS < Abstract

    file_extension 'less'

    #
    def less(*)
      text
    end

    #
    def to_less(*)
      self
    end

    #
    def css(*data, &content)
      render_into(:css, *data, &content)
      #opts = options.merge(:text=>text, :file=>file, :format=>:css)
      #render_engine.render(opts)
    end

    #
    def to_css(*data, &content)
      text = css(*data, &content)
      opts = options.merge(:text=>text, :file=>refile(:css), :type=>:css)
      CSS.new(opts)
    end

#  private
#
#    #
#    def render_engine
#      @render_engine ||= Malt::Engine::Less.new(options)
#    end

    # LESS default output type is CSS.
    def default
      :css
    end

  end

end

