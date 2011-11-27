testcase Malt::Engine::Haml do

  method :render do

    test "convert Haml DSL to XML by default" do
      e = Malt::Engine::Haml.new(:text=>"%h1 Testing")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Haml.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"%h1 Testing")
      end
    end

  end

  method :prepare_engine do

    test "returns an ::Haml::Engine instance" do
      e = Malt::Engine::Haml.new
      r = e.prepare_engine(:text=>"%h1 Testing")
      r.assert.is_a? ::Haml::Engine
    end

  end

end
