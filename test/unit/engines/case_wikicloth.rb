testcase Malt::Engine::WikiCloth do

  method :render do

    test "convert media wiki text to HTML by default" do
      e = Malt::Engine::WikiCloth.new(:text=>"== Testing ==")
      h = e.render
      h.assert.index "<h2>"       # so complicated that we're lucky to find it ;)
      h.assert.index "Testing"
    end

  end

  method :intermediate do

    test "returns a WikiCloth instance" do
      e = Malt::Engine::WikiCloth.new
      r = e.intermediate(:text=>"== Testing ==")
      r.assert.is_a? ::WikiCloth::WikiCloth
    end

  end

end

