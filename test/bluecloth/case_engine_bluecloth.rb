testcase Malt::Engine::BlueCloth do

  method :render do

    test "convert BlueCloth text" do
      e = Malt::Engine::BlueCloth.new(:text=>"# Testing")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::BlueCloth.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"# Testing")
      end
    end

  end

  method :intermediate do

    test "returns an ::BlueCloth instance" do
      e = Malt::Engine::BlueCloth.new
      r = e.intermediate(:text=>"# Testing")
      r.assert.is_a? ::BlueCloth
    end

  end

end
