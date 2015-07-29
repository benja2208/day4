class Board
  DEFAULT_SIZE = 10
  attr_reader :size, :grid, :ships, :coordinates, :hits, :misses, :used_coordinates

  def initialize(size_board = DEFAULT_SIZE)
    @grid = Array.new(size_board) { Array.new(size_board, '0') }
    @ships = []
    @coordinates = {}
    @used_coordinates = []
    @hits = []
    @misses = []
    @size = size_board
  end

  def see_board
    @grid.each { |x| puts x.join(' ') }
    nil
  end

  def place(ship, coord, orientation)
    coords_combined = convert(ship.size, coord, orientation)
    # fail 'No overlapping ships' unless (coords_combined & ships).empty?
    # fail 'Must be on the board' if coords_combined.any? { |n| n < 0 }
    # fail 'Must be on the board' if coords_combined.any? { |n| n > 100 }
    mark(ship, coord, orientation)
    @ships += coords_combined
    coords_combined.each { |coords| @coordinates[coords] = ship }
  end

  def mark(ship, coord, orientation)
    array = all_coords(ship.size, coord, orientation)
    raise 'Outside the board' if any_coord_not_on_board?(array)
    raise 'Those coordinates are already used!' unless coordinates_exist?(array)
    array.each do |coords|
      grid[coords.last][coords.first] = 'X'
      @used_coordinates << coord
    end
    see_board
  end

  def convert(size, coord, orientation)
    letters = (coord.to_s.scan(/\d+|[A-Z]+/)[0])
    number = (coord.to_s.scan(/\d+|[A-Z]+/)[1]).to_i
    range = (0..(size - 1))
    case orientation
    when :Horizontally then array = range.map { |n| subs(letters, n) + number.to_s }
    when :Vertically then array = range.map { |n| letters + (number + n).to_s }
    end
    array.map(&:to_sym)
  end

  def subs(letter, n)
    n.times { letter = letter.next }
    letter
  end

  def prev(letter, n)
    n.times { letter = (letter.chr.ord - 1).chr }
    letter
  end

  def all_coords(size, coord, orientation)
    coords = [coord]
    (size - 1).times { coords << (orientation == :vertically ? coords.last.next : next_vertical_coord(coords.last)) }
    coords.map { |coordinate| convert_to_array(coordinate) }
  end

  def convert_to_array(coordinate)
    x = coordinate.to_s.scan(/\d+|[A-Z]+/)[0]
    y = coordinate.to_s.scan(/\d+|[A-Z]+/)[1]
    [x.ord - 65, y.to_i - 1]
  end

  def next_vertical_coord(coord)
    coord.to_s.reverse.next.reverse.to_sym
  end

  def any_coord_not_on_board?(coords)
    coords.any? do |coord|
      grid[coord.last][coord.first].nil? rescue true
    end
  end

  # def store_data(ship, array)
  #   @ships += array
  #   array.each { |coord| @coordinates[coord] = ship }
  # end

  def coordinates_exist?(coords)
    (used_coordinates & coords).empty?
  end

  def hit_or_miss(x, y)
    grid[y][x] == '0' ? grid[y][x] = 'M' : grid[y][x] = 'H'
  end

  def fire(coords)
    if ships.include?(coords)
      coordinates[coords].got_hit
      ships.delete(coords)
      @hits << coords
      return :hit
    else
      @misses << coords
      return :miss
    end
    x = convert_to_array(coordinate)[0]
    y = convert_to_array(coordinate)[1]
    hit_or_miss(x, y)
  end

  def all_sunk?
    ships.empty?
  end
end
