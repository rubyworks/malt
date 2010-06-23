require 'malt/core_ext'

module Malt

  module Kernel

    ;;; private ;;;

    #
    def make_ostruct(hash)
      case hash
      when OpenStruct
        hash
      else
        OpenStruct.new(hash)
      end
    end

  end

end
