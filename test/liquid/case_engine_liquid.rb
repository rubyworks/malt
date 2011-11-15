testcase Malt::Engine::Liquid do

  method :render do

    test "convert ERB text" do
      e = Malt::Engine::Liquid.new(:text=>"<h1>{{ title }}</h1>")
      h = e.render(:data=>{:title=>'Testing'})
      h.assert.index "<h1>Testing</h1>"
    end

    test "Liquid is converstion format agnostic" do
      e = Malt::Engine::Liquid.new
      e.render(:to=>:DNE, :text=>"<h1>{{ title }}</h1>")
    end

  end

  method :intermediate do

    test "returns a Liquid instance" do
      e = Malt::Engine::Liquid.new
      r = e.intermediate(:text=>"<h1>{{ title }}</h1>")
      r.assert.is_a? ::Liquid::Template
    end

  end

end
