testcase Malt::Engine::Erector do

  method :render do

    test "convert Erector template" do
      e = Malt::Engine::Erector.new(:text=>"h1 'Testing'")
      h = e.render
      h.assert.index "<h1>Testing</h1>"
    end

  end

  # NOTE: truth is these will probably become private so there isn't 
  # really necessary to test them directly.

  method :prepare_engine do

    test "returns an instance of a subclass of Erector::Widget" do
      e = Malt::Engine::Erector.new
      r = e.prepare_engine(:text=>"h1 'Testing'")
      assert r.is_a?(::Erector::Widget)  # do it this way b/c of odd warning
    end

  end

  method :create_engine do

    test "returns a subclass of Erector::Widget" do
      e = Malt::Engine::Erector.new
      r = e.create_engine(:text=>"h1 'Testing'")
      r.assert < ::Erector::Widget
    end

  end

end
