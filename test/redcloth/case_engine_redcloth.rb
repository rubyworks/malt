testcase Malt::Engine::RedCloth do

  method :render do

    test "convert RedCloth text" do
      e = Malt::Engine::RedCloth.new(:text=>"h1. Testing")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::RedCloth.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"h1. Testing")
      end
    end

  end

  method :prepare_engine do

    test "returns an ::RedCloth instance" do
      e = Malt::Engine::RedCloth.new
      r = e.prepare_engine(:text=>"h1. Testing")
      #RedCloth.assert === r
      String.assert === r
    end

  end

end
