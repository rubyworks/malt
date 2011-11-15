testcase Malt::Engine::RDiscount do

  method :render do

    test "convert RDiscount text" do
      e = Malt::Engine::RDiscount.new(:text=>"# Testing")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::RDiscount.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"# Testing")
      end
    end

  end

  method :intermediate do

    test "returns an ::RDiscount instance" do
      e = Malt::Engine::RDiscount.new
      r = e.intermediate(:text=>"# Testing")
      r.assert.is_a? ::RDiscount
    end

  end

end
