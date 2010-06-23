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
  #--
  # TODO: Use #method_missing is we get many more file types to support.
  #++
  class Ruby < Abstract

    register('rb')

    #
    #def ruby(db, &yld)
    #  self #? db, &yld)
    #end

    #
    #def txt(db, &yld)
    #  convert(:txt, db, &yml)
    #end

    #
    #def html(db, &yld)
    #  convert(:html, db, &yld)
    #end

    #
    #def latex(db, &yld)
    #  convert(:latex, db, &yld)
    #end

    #
    #def pdf(db, &yld)
    #  convert(:pdf, db, &yld)
    #end

    #
    #def rdoc(db, &yld)
    #  convert(:rdoc, db, &yld)
    #end

    ;;;; private ;;;;

    #
    def render(to, db, &yld)
      engine.render(text, file, db, &yld)
    end

    #
    def engine
      @engine ||= Malt::Engines::Ruby.new(options)
    end

  end

end
