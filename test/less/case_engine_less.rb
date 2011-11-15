testcase Malt::Engine::Less do

  method :render do

    test "convert LESS to CSS" do
      e = Malt::Engine::Less.new
      h = e.render(:text=>"#menu {\n  margin: 0; }")
      h.assert.index "#menu {\n  margin: 0;\n}\n"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Less.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"#menu {\n  margin: 0; }")
      end
    end

  end

  method :intermediate do

    test "returns an ::Less instance" do
      e = Malt::Engine::Less.new
      r = e.intermediate(:text=>"#menu {\n  margin: 0; }")
      r.assert.is_a? ::Less::Parser
    end

  end

end
