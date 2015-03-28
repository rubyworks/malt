require 'ostruct'
require 'facets/module/basename'
#require 'facets/to_hash'
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

  # Create a new binding incorporating the current binding and
  # the given local settings hash and yield block.
  #
  # The yield code was neccessary b/c Ruby does not respect the use
  # of yield in a lambda (boo hiss). 
  def with(_hash, &_yield)
    _hash = (_hash || {}).to_h #ash

    if _yield
      vars = eval('local_variables')
      vals = eval("[#{vars.join(',')}]")

      vars += _hash.keys
      vals += _hash.values

      code = <<-END
        def self.___with(#{vars.join(',')})
          binding
        end
        method(:___with)
      END
      eval(code).call(*vals, &_yield)

      #_args = _hash.empty? ? '' : '|' + _hash.keys.join(',') + ',&y|'
      #lamb = eval("lambda{#{_args} binding}")
      #(class << self; self; end).send(:define_method, :__temp__, &lamb)
      #method(:__temp__).call(*_hash.values, &_yield)
    else
      _args = _hash.empty? ? '' : '|' + _hash.keys.join(',') + '|'
      eval("lambda{#{_args} binding}").call(*_hash.values)
    end
  end
end

class Object
  def to_binding
    binding
  end
end

class Struct
  def to_struct
    self
  end

  def to_h
    Hash[members.zip(values)]
  end unless method_defined?(:to_h)

  #def to_hash
  #  Hash[members.zip(values)]
  #end
end

#class Array
  #def to_struct
  #  h = to_h
  #  Struct.new(h.keys)
  #end

  #def to_h
  #  Hash[*self]
  #end unless method_defined?(:to_h)
#end

class OpenStruct
  def to_struct
    self
  end

  #
  def to_h #ash
    @table.dup
  end unless method_defined?(:to_h)
end

unless defined?(::BasicObject)
  require 'blankslate'
  ::BasicObject = ::BlankSlate
end

