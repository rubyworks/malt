testcase Malt::Engine::Haml do

  method :render do

    test "convert Haml DSL to XML by default" do
      e = Malt::Engine::Haml.new
      h = e.render(:text=>"%h1 Testing")
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Haml.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"%h1 Testing")
      end
    end

  end

  method :intermediate do

    test "returns an ::Haml::Engine instance" do
      e = Malt::Engine::Haml.new
      r = e.intermediate(:text=>"%h1 Testing")
      r.assert.is_a? ::Haml::Engine
    end

  end

end
