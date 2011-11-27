require 'malt/formats/abstract'
require 'malt/formats/css'
require 'malt/engines/sass'

module Malt::Format

  # Sass Format
  #
  #
  class Sass < Abstract

    file_extension 'sass'

    #
    def sass(*)
      text
    end

    #
    def to_sass(*)
      self
    end

    #
    def css(*data, &content)
      render_into(:css, *data, &content)
      #render_engine.render(:format=>:css, :text=>text, :file=>file, :data=>data, :type=>type, &yld)
    end

    #
    def to_css(*data, &content)
      result = css(*data, &content)
      CSS.new(:text=>result, :file=>refile(:css), :type=>:css)
    end

    #
    #def compile(db, &yld)
    #  result = render_engine.render(text, db, &yld)
    #  opts = options.merge(:text=>result, file=>refile(:css))
    #  CSS.new(opts)
    #end

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

