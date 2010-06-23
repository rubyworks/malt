require 'malt/engines/abstract'

module Malt::Engines

  # ERB template implementation.
  #
  #   http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/classes/ERB.html
  #
  # ERB templates accept two options. +safe+ sets the safe mode for
  # rendering the template and +trim+ is a weird string that controls
  # a few rendering options --it can be '%' and/or '>' or '<>'.
  class Erb < Abstract

    #
    def intermediate(text,file=nil)
      ::ERB.new(text, safe, trim)
    end

    # Compile template into Ruby source code.
    def compile(text, file)
      intermediate(text,file).src
    end

    #
    def render(text, file, db, &yld)
      db = make_binding(db, &yld)
      intermediate(text,file).result(db)
    end

    #
    def safe
      options[:safe]
    end

    #
    def trim
      options[:trim]
    end

    ;;;; private ;;;;

    # Load ERB library if not already loaded.
    def initialize_engine
      return if defined? ::ERB
      require_library('erb')
    end

  end

end

