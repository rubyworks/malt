testcase Malt::Engine::Tenjin do

  method :render do

    test "render text" do
      e = Malt::Engine::Tenjin.new(:text=>'<h1>#{title}</h1>')
      h = e.render(:locals=>{:title=>'Testing'})
      h.assert.index "<h1>Testing</h1>"
    end

    test "Tenjin is converstion format agnostic" do
      e = Malt::Engine::Tenjin.new
      e.render(:to=>:DNE, :text=>'<h1>#{@title}</h1>')
    end

  end

  method :prepare_engine do

    test "returns a Tenjin instance" do
      e = Malt::Engine::Tenjin.new
      r = e.prepare_engine(:text=>'<h1>#{@title}</h1>')
      #r.assert.is_a? ::Tenjin::Template
    end

  end

end
