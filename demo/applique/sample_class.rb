
# TODO:  Had to use `::` b/c of QED limitation. Report issue.

class ::SampleObject
  attr :name
  attr :state
  def initialize(name,state)
    @name = name
    @state = state
  end
end
