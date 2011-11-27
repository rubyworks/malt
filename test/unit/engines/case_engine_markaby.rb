testcase Malt::Engine::Markaby do

  method :render do

    test "convert Markaby DSL to XML by default" do
      e = Malt::Engine::Markaby.new
      h = e.render(:text=>%[h1 "Testing"])
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Markaby.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>%[h1 "Testing"])
      end
    end

  end

end
