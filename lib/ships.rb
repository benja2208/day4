class Ship
  attr_reader :size, :hits

  def initialize(size)
    @size = size
    @hits = 0
  end

  def self.patrol_boat
    Ship.new(2)
  end

  def self.destroyer
    Ship.new(3)
  end

  def self.submarine
    Ship.new(3)
  end

  def self.battleship
    Ship.new(4)
  end

  def self.aircraft_carrier
    Ship.new(5)
  end

  def got_hit
    @hits += 1
  end

  def sunk?
    hits == size
  end
end
