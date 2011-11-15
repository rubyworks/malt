testcase Malt::Engine::Erector do

  method :render do

    test "convert Erector template" do
      e = Malt::Engine::Erector.new(:text=>"h1 'Testing'")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

  end

  method :intermediate do

    test "returns a subclass of Erector::Widget instance" do
      e = Malt::Engine::Erector.new
      r = e.intermediate(:text=>"h1 'Testing'")
      r.assert < ::Erector::Widget
    end

  end

end
