require 'malt/formats/abstract'
require 'malt/engines/erb'

module Malt::Format

  # Yes, pure Ruby as a template format.
  #
  # The ruby code is run through eval and whatever it returns is given
  # as the rendering.
  #
  # The Ruby format is a *polyglot* format --it accepts all conversion
  # types and assumes the end-user knows it will be the result.
  #
  # In the future, the Ruby type might also used for "precompiling" other
  # formats such as ERB.
  #
  class Ruby < AbstractTemplate

    file_extension 'rb'

    #
    def rb(*)
      text
    end

    alias_method :ruby, :rb

    #
    def to_rb(*)
      self
    end

    alias_method :to_ruby, :to_rb

  end

end
