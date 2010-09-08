require 'malt/core_ext'

module Malt

  module Kernel
    private

    #
    def make_ostruct(hash)
      case hash
      when OpenStruct
        hash
      else
        OpenStruct.new(hash)
      end
    end

    #
    def ext_to_type(ext)
      ext = ext.to_s.downcase
      return nil if ext.empty?
      if ext[0,1] == '.'
        ext[1..-1].to_sym
      else
        ext.to_sym
      end
    end

  end

end
