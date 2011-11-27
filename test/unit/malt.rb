testcase Malt do

  class_method :render do

    test "corrent engine is used when specified" do
      Malt.render(:text=>"<%= title %>", :type=>:erb, :engine=>:erubis, :data=>{:title=>'Testing'})
    end

  end


end
