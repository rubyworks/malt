require 'malt/formats/abstract'

module Malt::Format

  #
  class Javascript < Abstract

    register 'javascript', 'js'

    #
    def javascript(*)
      text
    end
    alias_method :js, :javascript

    #
    def to_javascript(*)
      self
    end
    alias_method :to_js, :to_javascript

    private

    #
    def render_engine
    end

  end

end

