class Tile

  attr_accessor :showing, :value, :flagged

  def initialize(value="-")
    @showing = false
    @flagged = false
    @value = value
  end

  def reveal
    @showing = true
  end

  def flag
    @flagged = true
  end

  def unflag
    @flagged = false
  end

end
