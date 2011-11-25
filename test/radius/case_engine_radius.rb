testcase Malt::Engine::Radius do

  method :render do

    test "convert Radius DSL to XML by default" do
      e = Malt::Engine::Radius.new
      h = e.render(:text=>"<h1>Testing</h1>")
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Radius.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"<h1>Testing</h1>")
      end
    end

  end

  method :prepare_engine do

    test "returns an instance of a subclass of ::Radius::Context" do
      e = Malt::Engine::Radius.new
      r = e.prepare_engine(:text=>"<h1>Testing</h1>")
      r.assert.is_a? ::Radius::Context
    end

  end

end
