require 'malt/engines/abstract'

module Malt::Engines

  # Erubis template implementation.
  #
  #   http://www.kuwata-lab.com/erubis/
  #
  # Erubis is essentially compatibel with ERB, but it is faster.
  #
  class Erubis < Abstract

    # TODO: register this engine with the formats it supports.
    #register(:erb)

    #
    def intermediate(text, file=nil)
      if options.delete(:escape_html)
        ::Erubis::EscapedEruby.new(text, options)
      else
        ::Erubis::Eruby.new(text, options)
      end
    end

    # Compile template into Ruby source code.
    def compile(text, file)
      intermediate(text, file).src
    end

    # Render template.
    def render(text, file, db, &yld)
      db = make_binding(db, &yld)
      intermediate(text, file).result(db)
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

