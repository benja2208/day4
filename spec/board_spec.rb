require 'board'

describe Board do
	let(:board) {Board.new}
	before{allow(board).to receive(:see_board)}
	let(:ship){double :ship, size: 2}

	it ' it initiatiates with default 10x10 grid' do 
    expect(board.grid.count).to eq 10
  end 

  it 'can have any size' do 
    small_board = Board.new 4
    expect(small_board.grid.count).to eq 4
  end

  
  describe '#placing ' do 
    it { is_expected.to respond_to(:place).with(3).argument }

    it 'places a ship in its position(vertically)' do
      board.place(ship,:A1, :vertically)
      expect(board.grid[1][0]).to eq 'X'
    end

    it 'places a ship in its position(vertically)' do
      board.place(ship,:A1, :horizontally)
      expect(board.grid[0][1]).to eq 'X'
    end


    it 'will not place a ship beyond the board' do
      expect{board.place(ship,:J10,:vertically)}.to raise_error('Outside the board')
    end

    it 'cannot place a ship on another one' do 
      board.place(ship,:B2,:vertically)
      expect{board.place(ship,:B2,:vertically)}.to raise_error 'Those coordinates are already used!'
    end 
  end

  it "says 'H' for a hit" do
    board.place(ship,:A1,:vertically)
    expect(board.hit_or_miss(0,0)).to eq 'H'
  end

end 