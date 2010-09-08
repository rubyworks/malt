require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'

module Malt::Formats

  # Yes, pure Ruby as a template format.
  #
  # The ruby code is run through eval and whatever is returned is given
  # as the rendering.
  #
  # The Ruby format is a *polyglot* format --it accepts all conversion
  # types and assumes the end-user knows it will be the result.
  #
  # The Ruby type is also used for "precompiling" other formats such
  # as ERB.
  #
  class Ruby < Abstract

    register('rb')

    #
    def render(data, &yld)
      render_engine.render(:text=>text, :file=>file, :data=>data, &yld)
    end

    #
    def rb ; text ; end
    alias_method :ruby, :rb

    #
    def to_rb ; self ; end
    alias_method :to_ruby, :to_rb

    #
    #def render_to(to, db, &yld)
    #  malt_engine.render(text, file, db, &yld)
    #end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engines::Ruby.new(options)
    end

  end

end
