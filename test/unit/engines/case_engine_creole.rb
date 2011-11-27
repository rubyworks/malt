testcase Malt::Engine::Creole do

  method :render do

    test "convert media wiki text to HTML by default" do
      e = Malt::Engine::Creole.new(:text=>"== Testing ==")
      h = e.render
      h.assert.index "<h2>"       # so complicated that we're lucky to find it ;)
      h.assert.index "Testing"
    end

  end

  method :prepare_engine do

    test "returns a Creole instance" do
      e = Malt::Engine::Creole.new
      r = e.prepare_engine(:text=>"== Testing ==")
      r.assert.is_a? ::Creole::Parser
    end

  end

  method :create_engine do

    test "returns a Creole instance" do
      e = Malt::Engine::Creole.new
      r = e.create_engine(:text=>"== Testing ==")
      r.assert.is_a? ::Creole::Parser
    end

  end

end

