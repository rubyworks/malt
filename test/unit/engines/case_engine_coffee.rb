testcase Malt::Engine::Coffee do

  method :render do

    test "convert Coffee text" do
      e = Malt::Engine::Coffee.new(:text=>"square = (x) -> x * x")
      h = e.render
      h.assert.index "square = function(x) {\n    return x * x;\n  };"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Coffee.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"square = (x) -> x * x")
      end
    end

  end

  #method :intermediate do
  #
  #  test "returns an ::Coffee instance" do
  #    e = Malt::Engine::Coffee.new
  #    r = e.intermediate(:text=>"square = (x) -> x * x")
  #    r.assert.is_a? ::Coffee
  #  end
  #
  #end

end
