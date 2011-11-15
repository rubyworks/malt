testcase Malt::Engine::Kramdown do

  method :render do

    test "convert Kramdown text" do
      e = Malt::Engine::Kramdown.new(:text=>"# Testing")
      h = e.render
      h.assert.index %{<h1 id="testing">Testing</h1>}
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Kramdown.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"# Testing")
      end
    end

  end

  method :intermediate do

    test "returns an ::Kramdown instance" do
      e = Malt::Engine::Kramdown.new
      r = e.intermediate(:text=>"# Testing")
      r.assert.is_a? ::Kramdown::Document
    end

  end

end
