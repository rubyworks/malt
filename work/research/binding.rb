require File.dirname(__FILE__) + '/../../lib/malt/core_ext'

class X
  def a
    a = 1
    binding
  end

  def b(&b)
    a.with(:b=>2, &b)
  end
end

x = X.new

r = x.b{ 1+1+1+1 }

p r.eval('a')

p r.eval('b')

p r.eval('yield')
