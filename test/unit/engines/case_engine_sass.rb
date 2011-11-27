testcase Malt::Engine::Sass do

  method :render do

    test "convert SASS to CSS by default" do
      e = Malt::Engine::Sass.new(:text=>"#menu\n  :margin 0")
      h = e.render
      h.assert.index "#menu {\n  margin: 0; }\n"
    end

    test "convert SCSS to CSS" do
      e = Malt::Engine::Sass.new
      h = e.render(:text=>"#menu{ margin: 0 }", :type=>:scss)
      h.assert.index "#menu {\n  margin: 0; }\n"
    end

    test "raises NotImplementedError if converstion format not supported" do
      e = Malt::Engine::Sass.new
      expect NotImplementedError do
        e.render(:to=>:DNE, :text=>"#menu\n  :margin 0")
      end
    end

  end

  method :prepare_engine do

    test "returns an ::Sass instance" do
      e = Malt::Engine::Sass.new
      r = e.prepare_engine(:text=>"#menu\n  :margin 0")
      r.assert.is_a? ::Sass::Engine
    end

  end

end
