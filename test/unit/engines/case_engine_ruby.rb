testcase Malt::Engine::Ruby do

  method :render do

    test "convert Ruby Ruby text" do
      e = Malt::Engine::Ruby.new(:text=>%q{"Hello " + title})
      h = e.render(:data=>{:title=>'World!'})
      h.assert.index "Hello World!"
    end

    test "Ruby is converstion format agnostic" do
      e = Malt::Engine::Ruby.new
      e.render(:to=>:DNE, :text=>%q{"Hello " + title}, :data=>{:title=>'World!'})
    end

  end

  #method :prepare_engine do
  #
  #  test "returns an ::Ruby instance" do
  #    e = Malt::Engine::Ruby.new
  #    r = e.prepare_engine(:text=>%q{"Hello #{title}")
  #    r.assert.is_a? ::Ruby
  #  end
  #
  #end

end
