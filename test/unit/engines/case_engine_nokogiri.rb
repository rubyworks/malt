testcase Malt::Engine::Nokogiri do

  method :render do

    test "convert Nokogiri DSL to XML by default" do
      e = Malt::Engine::Nokogiri.new(:text=>%[h1 "Testing"])
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Nokogiri.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>%[h1 "Testing"])
      end
    end

  end

  method :prepare_engine do

    test "returns a ::Nokogiri::XML::Builder instance" do
      e = Malt::Engine::Nokogiri.new
      r = e.prepare_engine(:text=>%[h1 "Testing"])
      r.assert.is_a? ::Nokogiri::XML::Builder
    end

  end

end
