testcase Malt::Engine::String do

  method :render do

    test "render text" do
      e = Malt::Engine::String.new(:text=>%q{"Hello #{title}"})
      h = e.render(:locals=>{:title=>'World!'})
      h.assert.index "Hello World!"
    end

    test "String is converstion format agnostic" do
      e = Malt::Engine::String.new
      e.render(:to=>:DNE, :text=>%q{"Hello #{title}"}, :locals=>{:title=>'World!'})
    end

  end

  #method :prepare_engine do
  #
  #  test "returns an ::String instance" do
  #    e = Malt::Engine::String.new
  #    r = e.prepare_engine(:text=>%q{"Hello #{title}")
  #    r.assert.is_a? ::String
  #  end
  #
  #end

end
