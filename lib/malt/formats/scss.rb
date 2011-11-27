require 'malt/formats/abstract'
require 'malt/formats/css'
require 'malt/engines/sass'

module Malt::Format

  # SCSS Format
  #
  # This uses the same engine as Sass.
  class SCSS < Abstract

    file_extension 'scss'

    #
    def scss(*)
      text
    end

    #
    def to_scss(*)
      self
    end

    #
    def css(*data, &content)
      render_into(:css, *data, &content)
    end

    #
    def to_css(*data, &content)
      result = css(*data, &content)
      CSS.new(:text=>result, :file=>refile(:css), :type=>:css)
    end

   private

    ##
    #def render_engine
    #  @render_engine ||= Malt::Engine::Sass.new(options)
    #end

    # Sass default output type is CSS.
    def default
      :css
    end

  end

end

