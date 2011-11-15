testcase Malt::Engine::Mustache do

  method :render do

    test "convert ERB text" do
      e = Malt::Engine::Mustache.new(:text=>"<h1>{{ title }}</h1>")
      h = e.render(:data=>{:title=>'Testing'})
      h.assert.index "<h1>Testing</h1>"
    end

    test "Mustache is converstion format agnostic" do
      e = Malt::Engine::Mustache.new
      e.render(:to=>:DNE, :text=>"<h1>{{ title }}</h1>")
    end

  end

  #method :intermediate do
  #
  #  test "returns a Mustache instance" do
  #    e = Malt::Engine::Mustache.new
  #    r = e.intermediate(:text=>"<h1>{{ title }}</h1>")
  #    r.assert.is_a? ::Mustache
  #  end
  #
  #end

end
