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


class Binding
  # Conversion for bindings.
  #
  # @todo Is there any way to integrate the optional data and block?
  def to_binding
    self
  end

  #
  def self
    Kernel.eval('self', self)
  end

  #
  def with(_variables={}, &yields)
    obj = self.self
    hoc = (class << obj; self; end)
    (_variables || {}).to_hash.each do |name,value|
      hoc.__send__(:define_method, name){ value }
    end
    #if yields
    #  hoc.__send__(:define_method, :yield, &yields)
    #end
    obj.to_binding
  end
end

class Object
  def to_binding
    binding
  end
end

