testcase Malt::Engine::Builder do

  method :render do

    test "convert Builder DSL to XML by default" do
      e = Malt::Engine::Builder.new(:text=>%[h1 "Testing"])
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Builder.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>%[h1 "Testing"])
      end
    end

  end

  method :create_engine do

    test "returns an ::Builder::XmlMarkup instance" do
      e = Malt::Engine::Builder.new
      r = e.create_engine(:text=>%[h1 "Testing"])
      r.assert.is_a? ::Builder::XmlMarkup
    end

  end

end
