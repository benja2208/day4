require_relative 'board'

class Player
	attr_reader  :board

	def initialize (board)
      @board = board
  end

	def fire (coordinate)
		x = convert_to_array(coordinate)[0]
		y = convert_to_array(coordinate)[1]
    board.hit_or_miss(x,y)
    board.fire(coordinate)
  end

  def convert_to_array(coordinate)
	   x = coordinate.to_s.scan(/\d+|[A-Z]+/)[0]
	   y = coordinate.to_s.scan(/\d+|[A-Z]+/)[1]
	   [x.ord - 65,y.to_i - 1]
  end
end
