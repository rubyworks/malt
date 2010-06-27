require 'malt/engines/abstract'

module Malt::Engines

  # RTALS
  #
  #  http://github.com/rubyworks/rtals
  #
  class RTALS < Abstract

    #
    def intermediate(text, file=nil)
      ::RTAL.new(text)
    end

    #
    def render_html(text, file, db, &yld)
      db = make_binding(db, &yld)
      intermediate(text, file).compile(db).to_s
    end

    ;;;; private ;;;;

    # Load Haml library if not already loaded.
    def initialize_engine
      return if defined? ::RTAL
      require_library 'rtals'
    end

  end

end

