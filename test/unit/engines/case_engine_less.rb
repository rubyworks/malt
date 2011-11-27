testcase Malt::Engine::Less do

  method :render do

    test "convert LESS to CSS" do
      e = Malt::Engine::Less.new(:text=>"#menu {\n  margin: 0; }")
      h = e.render
      h.assert.index "#menu {\n  margin: 0;\n}\n"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Less.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"#menu {\n  margin: 0; }")
      end
    end

  end

  method :prepare_engine do

    test "returns an Less::Tree instance" do
      e = Malt::Engine::Less.new
      r = e.prepare_engine(:text=>"#menu {\n  margin: 0; }")
      r.assert.is_a? ::Less::Tree
    end

  end

  method :create_engine do

    test "returns an Less::Tree instance" do
      e = Malt::Engine::Less.new
      r = e.create_engine(:text=>"#menu {\n  margin: 0; }")
      r.assert.is_a? ::Less::Tree
    end

  end

end
