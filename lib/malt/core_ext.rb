require 'ostruct'
require 'facets/module/basename'
require 'facets/to_hash'
require 'facets/hash/rekey'

=begin
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
=end

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
  def itself
    eval('self')
  end

  #
  def with(_hash, &_yield)
    _hash = (_hash || {}).to_hash

#    _args = (_hash.keys + ['&yld']).join(',')
#    eval <<-END
#     (class << self; self; end).class_eval do
#       define_method(:_with) do |#{_args}|
#         binding
#       end
#     end
#    END
#    #(class << self; self; end).class_eval(code)
#    b = self.self._with(*_hash.values, &_yield)
#    #(class << self; self; end).class_eval{ remove_method(:_with) }
#    return b

    #args = (_hash.keys + ['&yld']).join(',')
    #eval("Proc.new{ |#{args}| binding }").call(*_hash.values, &_yield)

    args = _hash.keys.join(',')
    eval("lambda {|#{args}| binding}").call(*_hash.values)
  end

end

class Object
  def to_binding
    binding
  end
end


