testcase Malt::Engine::RagTag do

  method :render do

    test "convert RagTag DSL to XML by default" do
      e = Malt::Engine::RagTag.new
      h = e.render(:text=>"<h1>Testing</h1>")
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::RagTag.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"<h1>Testing</h1>")
      end
    end

  end

  method :prepare_engine do

    test "returns an ::Nokogiri document" do
      e = Malt::Engine::RagTag.new
      r = e.prepare_engine(:text=>"<h1>Testing</h1>")
      r.assert.is_a? ::Nokogiri::XML::Document
    end

  end

  method :create_engine do

    test "returns an ::RagTag::Engine instance" do
      e = Malt::Engine::RagTag.new
      r = e.create_engine(:text=>"<h1>Testing</h1>")
      r.assert.is_a? ::RagTag
    end

  end

end
