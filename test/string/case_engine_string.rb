testcase Malt::Engine::String do

  method :render do

    test "convert Ruby String text" do
      e = Malt::Engine::String.new(:text=>%q{"Hello #{title}"})
      h = e.render(:data=>{:title=>'World!'})
      h.assert.index "Hello World!"
    end

    test "String is converstion format agnostic" do
      e = Malt::Engine::String.new
      e.render(:to=>:DNE, :text=>%q{"Hello #{title}"}, :data=>{:title=>'World!'})
    end

  end

  #method :intermediate do
  #
  #  test "returns an ::String instance" do
  #    e = Malt::Engine::String.new
  #    r = e.intermediate(:text=>%q{"Hello #{title}")
  #    r.assert.is_a? ::String
  #  end
  #
  #end

end
