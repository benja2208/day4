require_relative 'board'

class Player
  attr_reader :board

  def initialize(board)
    @board = board
    @hits =  []
    @misses = []
  end

  def fire(coordinate)
    board.check(coordinate)
  end
end
