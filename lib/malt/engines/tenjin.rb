require 'malt/engines/abstract'

module Malt::Engines

  # Tenjin
  #
  #   http://www.kuwata-lab.com/tenjin/
  #
  # options
  #   :escapefunc=>'CGI.escapeHTML'
  #
  class Tenjin < Abstract

    #
    def compile(text, file)
      engine_template.convert(text, filename=file) 
    end

    #
    #def intermediate(text, file=nil)
    #  ::Tenjin::TemplEngine.parse(text)
    #end

    #
    def render(text, file, db, &yld)
      db = make_hash(db, &yld)
      template.convert(input, filename)
      template.render(db)
    end

    ;;;; private ;;;;

    def engine_template
      @engine_template ||= Tenjin::Template.new(options)
    end

    # Load Liquid library if not already loaded.
    def initialize_engine
      return if defined? ::Tenjin::Engine
      require_library 'tenjin'
    end

  end

end

