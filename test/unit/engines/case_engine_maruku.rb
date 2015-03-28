testcase Malt::Engine::Maruku do

  method :render do

    test "convert Maruku text" do
      e = Malt::Engine::Maruku.new(:text=>"# Testing")
      h = e.render
      h.assert.index '<h1 id="testing">Testing</h1>'
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Maruku.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"# Testing")
      end
    end

  end

  method :prepare_engine do

    test "returns an ::Maruku instance" do
      e = Malt::Engine::Maruku.new
      r = e.prepare_engine(:text=>"# Testing")
      r.assert.is_a? ::Maruku
    end

  end

end
