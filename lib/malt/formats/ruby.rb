require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'

module Malt::Formats

  # Yes, pure Ruby as a template format.
  #
  # The ruby code is run through eval and whatever
  # is returned is given as the rendering.
  #
  # The Ruby format is a *polyglot* format --it accepts
  # all conversion types and assumes the end-user knows
  # it will be the result.
  #
  # The Ruby type is also used for "precompiling" other
  # formats such as ERB.
  #
  class Ruby < Abstract

    register('rb')

    #
    #def ruby(db, &yld)
    #  self
    #end

    #
    def render_to(to, db, &yld)
      malt_engine.render(text, file, db, &yld)
    end

    ;;;; private ;;;;

    #
    def malt_engine
      @malt_engine ||= Malt::Engines::Ruby.new(options)
    end

  end

end
