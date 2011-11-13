  def binding1
    a = 1
    binding
  end

  def binding2
    b = 2
    binding
  end

  p eval('a', binding1)  #=> 1
  p eval('b', binding2)  #=> 2

  #p eval('a + b', binding1 + binding2)  #=> 3

  p eval('a+b', eval('binding2',binding1))

