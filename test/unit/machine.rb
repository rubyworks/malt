testcase Malt::Machine do

  method :engine do

    test "corrent engine is used when specified" do
      machine = Malt::Machine.new
      engine = machine.pry.engine(:erb,:erubis)
      engine.assert == Malt::Engine::Erubis
      #machine.render(:text=>"<%= title %>", :type=>:erb, :engine=>:erubis, :data=>{:title=>'Testing'})
      #RR.verify
    end

  end

  method :render do

    test "corrent engine is used when specified" do
      machine = Malt::Machine.new
      #mock(machine).engine(:erb,:erubis){ Malt::Engine::Erubis }
      machine.render(:text=>"<%= title %>", :type=>:erb, :engine=>:erubis, :data=>{:title=>'Testing'})
      #RR.verify
    end

  end


end
