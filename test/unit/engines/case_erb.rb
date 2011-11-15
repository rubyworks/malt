testcase Malt::Engine::Erb do

  method :render do

    test "convert ERB text" do
      e = Malt::Engine::Erb.new(:text=>"<h1><%= title %></h1>")
      h = e.render(:data=>{:title=>'Testing'})
      h.assert.index "<h1>Testing</h1>"
    end

  end

  method :intermediate do

    test "returns a WikiCloth instance" do
      e = Malt::Engine::Erb.new
      r = e.intermediate(:text=>"=<h1><%= title %></h1>")
      r.assert.is_a? ::ERB
    end

  end

end
