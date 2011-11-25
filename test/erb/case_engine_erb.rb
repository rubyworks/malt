testcase Malt::Engine::Erb do

  method :render do

    test "convert ERB text" do
      e = Malt::Engine::Erb.new(:text=>"<h1><%= title %></h1>")
      h = e.render(:data=>{:title=>'Testing'})
      h.assert.index "<h1>Testing</h1>"
    end

    test "Erb is converstion format agnostic" do
      e = Malt::Engine::Erb.new
      e.render(:to=>:DNE, :text=>"<h1>Testing</h1>")
    end

  end

  method :prepare_engine do

    test "returns an ERB instance" do
      e = Malt::Engine::Erb.new
      r = e.prepare_engine(:text=>"=<h1><%= title %></h1>")
      r.assert.is_a? ::ERB
    end

  end

end
