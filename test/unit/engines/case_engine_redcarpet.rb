testcase Malt::Engine::Redcarpet do

  method :render do

    test "render text" do
      e = Malt::Engine::Redcarpet.new(:text=>"# Testing")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Redcarpet.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"# Testing")
      end
    end

  end

  method :prepare_engine do

    test "returns an ::Redcarpet instance" do
      e = Malt::Engine::Redcarpet.new
      r = e.prepare_engine(:text=>"# Testing")
      r.assert.is_a? ::Redcarpet::Markdown
    end

  end

end
