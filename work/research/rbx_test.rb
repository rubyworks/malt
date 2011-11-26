#class Binding
#  def self
#    eval('self')
#  end
#end

#p binding.self


  class Binding
    def self_of_binding
      Kernel.eval('self', self)
    end
  end
  p binding.self_of_binding

