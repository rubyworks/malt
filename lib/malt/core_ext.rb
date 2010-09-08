require 'ostruct'
require 'facets/module/basename'

class Hash

  #
  def to_hash
    dup
  end unless method_defined?(:to_hash)

  #
  def rekey(&block)
    h = {}
    if block
      each{|k,v| h[block[k]] = v }
    else
      each{|k,v| h[k.to_sym] = v }
    end
    h
  end unless method_defined?(:rekey)

end

class OpenStruct

  #
  def to_hash
    @table.dup
  end unless method_defined?(:to_hash)

end
