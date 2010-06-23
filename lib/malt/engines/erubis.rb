require 'malt/engines/abstract'

module Malt::Engines

  # Erubis template implementation.
  #
  #   http://
  #
  # Erubis is essentially compatibel with ERB, but it is faster.
  #
  class Erubis < Abstract

    # TODO: register this engine with the formats it supports.
    #register(:erb)

    #
    def intermediate(text, file=nil)
      ::Erubis.new(text, safe, trim)
    end

    # Compile template into Ruby source code.
    def compile(text, file)
      intermediate.src
    end

    # Render template.
    def render(text, file, db, &yld)
      db = make_binding(db)
      intermediate.result(db)
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
      return if defined? ::Erubius
      require_library('erubis')
    end

  end

end

