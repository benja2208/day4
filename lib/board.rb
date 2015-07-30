class Board
  DEFAULT_SIZE = 10
  attr_reader :size, :grid, :ships, :coordinates, :hits, :misses

  def initialize(size_board = DEFAULT_SIZE)
    @grid = Array.new(size_board) { Array.new(size_board, '~') }
    @ships = []
    @coordinates = {}
    @hits = []
    @misses = []
    @size = size_board
  end

  def show
    @grid.each { |x| puts x.join(' ') }
    p
  end

  def place(ship, coord, orientation)
    coords_array = all_coords(ship.size, coord, orientation)
    fail 'No overlapping ships' unless (coords_array & ships).empty?
    array = coords_array.map { |coordinate| convert_to_array(coordinate) }
    mark_grid(array)
    store_data(ship, coords_array)
  end

  def mark_grid(array)
    fail 'Outside the board' if any_coord_not_on_board?(array)
    array.each { |coords| grid[coords.last][coords.first] = 'X' }
    show
  end

  def all_coords(size, coord, orientation)
    coords = [coord]
    (size - 1).times { coords << (orientation == :Vertically ? next_vertical_coord(coords.last) : next_horizontal_coord(coords.last)) }
    coords
  end

  def convert_to_array(coord)
    x = coord.to_s.scan(/\d+|[A-Z]+/)[0]
    y = coord.to_s.scan(/\d+|[A-Z]+/)[1]
    [x.ord - 65, y.to_i - 1]
  end

  def next_vertical_coord(coord)
    x = coord.to_s.scan(/\d+|[A-Z]+/)[0]
    y = coord.to_s.scan(/\d+|[A-Z]+/)[1]
    (x + y.next).to_sym
  end

  def next_horizontal_coord(coord)
    coord.to_s.reverse.next.reverse.to_sym
  end

  def any_coord_not_on_board?(coords)
    coords.any? do |coord|
      grid[coord.last][coord.first].nil? rescue true
    end
  end

  def store_data(ship, array)
    @ships += array
    array.each { |coord| @coordinates[coord] = ship }
    p
  end

  def check(coords)
    fail 'Outside the board' if any_coord_not_on_board?([convert_to_array(coords)])
    if ships.include?(coords)
      its_a_hit(coords)
    else
      its_a_miss(coords)
    end
  end

  def its_a_hit(coords)
    mark_ship(coords)
    mark_hit(coords)
    hit_log(coords)
  end

  def its_a_miss(coords)
    fail 'You have hit that spot already' if hits.include?(coords)
    fail 'You have miss that spot already' if misses.include?(coords)
    mark_miss(coords)
    miss_log(coords)
  end

  def mark_ship(coords)
    coordinates[coords].got_hit
    ships.delete(coords)
  end

  def mark_hit(coordinate)
    x = convert_to_array(coordinate)[0]
    y = convert_to_array(coordinate)[1]
    grid[y][x] = 'H'
  end

  def mark_miss(coordinate)
    x = convert_to_array(coordinate)[0]
    y = convert_to_array(coordinate)[1]
    grid[y][x] = 'M'
  end

  def hit_log(coords)
    @hits << coords
    :hit
  end

  def miss_log(coords)
    @misses << coords
    :miss
  end

  def all_sunk?
    ships.empty?
  end
end
