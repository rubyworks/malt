require 'malt/formats/abstract'

module Malt::Format

  #
  class Javascript < Abstract

    file_extension 'js'

    #
    def js(*)
      text
    end

    alias_method :javascript, :js

    #
    def to_js(*)
      self
    end

    alias_method :to_javascript, :to_js

  end

end

