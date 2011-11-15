testcase Malt::Engine::RDoc do

  method :render do

    test "convert RDoc text" do
      e = Malt::Engine::RDoc.new(:text=>"= Testing")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::RDoc.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"= Testing")
      end
    end

  end

  method :intermediate do

    test "returns an ::RDoc::Markup::ToHtml instance" do
      e = Malt::Engine::RDoc.new
      r = e.intermediate(:text=>"= Testing")
      r.assert.is_a? ::RDoc::Markup::ToHtml
    end

  end

end
