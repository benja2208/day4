class Board
	DEFAULT_SIZE = 10 
	attr_reader :size, :grid, :used_coordinates

	def initialize (size_board = DEFAULT_SIZE)
      @grid = Array.new(size_board) {Array.new(size_board,'0')}
      @used_coordinates= []
      @size = size_board
  end

  def see_board
    @grid.each do |r|
      puts r.map { |p| p }.join(" ")
    end 
    nil
  end 

  def place (ship, coord, orientation)
  	array = all_coords(ship.size, coord.upcase, orientation)
    raise 'Outside the board' if any_coord_not_on_board?(array)
    raise 'Those coordinates are already used!' unless coordinates_exist?(array)
    array.each do |coord|
    grid[coord.last][coord.first] = 'X'
    @used_coordinates << coord
    end
    see_board
  end

  def all_coords size, coord, orientation
    coords = [coord]
    (size - 1).times {coords << (orientation == :vertically ? coords.last.next : next_vertical_coord(coords.last))}
    coords.map{|coordinate|convert_to_array(coordinate)}
  end

  def convert_to_array(coordinate)
   x = coordinate.to_s.scan(/\d+|[A-Z]+/)[0]
   y = coordinate.to_s.scan(/\d+|[A-Z]+/)[1]
   [x.ord - 65,y.to_i - 1]
  end

  def next_vertical_coord(coord)
    coord.to_s.reverse.next.reverse.to_sym
  end

  def any_coord_not_on_board?(coords)
    coords.any? do |coord|
    grid[coord.last][coord.first].nil? rescue true 
  	end 
  end

  def coordinates_exist?(coords)
  	(used_coordinates & coords).empty?
  end

  def hit_or_miss (x,y) 
  	grid[y][x] == '0' ? grid[y][x] = 'M' : grid[y][x] = 'H' 
  end 
end 