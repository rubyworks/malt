require 'ostruct'

class Hash

  #
  def to_hash
    dup
  end

  #
  def rekey(&block)
    h = {}
    if block
      each{|k,v| h[block[k]] = v }
    else
      each{|k,v| h[k.to_sym] = v }
    end
    h
  end

end

class OpenStruct

  #
  def to_hash
    @table.dup
  end

end
