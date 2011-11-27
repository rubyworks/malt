testcase Malt::Engine::Erubis do

  method :render do

    test "convert ERB text" do
      e = Malt::Engine::Erubis.new(:text=>"<h1><%= title %></h1>")
      h = e.render(:data=>{:title=>'Testing'})
      h.assert.index "<h1>Testing</h1>"
    end

    test "Erubis is converstion format agnostic" do
      e = Malt::Engine::Erubis.new
      e.render(:to=>:DNE, :text=>"<h1>Testing</h1>")
    end

  end

  method :prepare_engine do

    test "returns a Erubius::Eruby instance" do
      e = Malt::Engine::Erubis.new
      r = e.prepare_engine(:text=>"<h1><%= title %></h1>")
      r.assert.is_a? ::Erubis::Eruby
    end

  end

end
