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

require 'board'

describe Board do
  let(:rand_num) { 55 }
  let(:ship) { double :ship }
  before(:each) { allow(ship).to receive(:got_hit) }

  describe '#place' do
    it 'should respond to place with 3 arguments' do
      expect(subject).to respond_to(:place).with(3).argument
    end

    it 'should not allow ships to overlap' do
      allow(ship).to receive(:size) { 2 }
      subject.place(ship, rand_num, :E)
      expect { subject.place(ship, rand_num + 1, :N) }.to\
        raise_error 'No overlapping ships'
    end

    context 'Ships (Size 1)' do
      before(:each) { allow(ship).to receive(:size) { 1 } }
      it 'should place a ship of size 1 on the board' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships.length).to eq 1
      end

      it 'should keep track of the coordinates of the ship' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships).to eq [rand_num]
      end

      it 'should keep track of which coordinates belong to the ship' do
        subject.place(ship, rand_num, :N)
        expect(subject.coordinates[rand_num]).to eq ship
      end

      it 'should keep track of which coordinates belong to the ship' do
        subject.place(ship, rand_num, :N)
        expect((subject.coordinates).length).to eq 1
      end
    end

    context 'Submarines (Size 2)' do
      before(:each) { allow(ship).to receive(:size) { 2 } }
      it 'should place a ship of size 2 on the board' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships.length).to eq 2
      end

      it 'should keep track of the coordinates of the submarine' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships).to eq [rand_num, rand_num - 1]
      end

      it 'should keep track of which coordinates belong to the submarine' do
        subject.place(ship, rand_num, :N)
        expect(subject.coordinates[rand_num]).to eq ship
        expect(subject.coordinates[rand_num - 1]).to eq ship
      end

      it 'should keep track of which coordinates belong to the submarine' do
        subject.place(ship, rand_num, :N)
        expect((subject.coordinates).length).to eq 2
      end

      it 'should place a ship facing north' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships).to eq [rand_num, rand_num - 1]
      end

      it 'should place a ship facing east' do
        subject.place(ship, rand_num, :E)
        expect(subject.ships).to eq [rand_num, rand_num + 10]
      end

      it 'should place a ship facing south' do
        subject.place(ship, rand_num, :S)
        expect(subject.ships).to eq [rand_num, rand_num + 1]
      end

      it 'should place a ship facing west' do
        subject.place(ship, rand_num, :W)
        expect(subject.ships).to eq [rand_num, rand_num - 10]
      end

      it 'should not be sticking off the sides' do
        expect { subject.place(ship, 100, :S) }.to\
          raise_error 'Must be on the board'
      end
    end

    context 'Destroyer (Size 3)' do
      before(:each) { allow(ship).to receive(:size) { 3 } }
      it 'should place a ship of size 3 on the board' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships.length).to eq 3
      end

      it 'should keep track of the coordinates of the destroyer' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships).to eq [rand_num, rand_num - 1, rand_num - 2]
      end

      it 'should keep track of which coordinates belong to the destroyer' do
        subject.place(ship, rand_num, :N)
        expect(subject.coordinates[rand_num]).to eq ship
        expect(subject.coordinates[rand_num - 1]).to eq ship
        expect(subject.coordinates[rand_num - 2]).to eq ship
      end

      it 'should keep track of which coordinates belong to the destroyer' do
        subject.place(ship, rand_num, :N)
        expect((subject.coordinates).length).to eq 3
      end

      it 'should place a ship facing north' do
        subject.place(ship, rand_num, :N)
        expect(subject.ships).to eq [rand_num, rand_num - 1, rand_num - 2]
      end

      it 'should place a ship facing east' do
        subject.place(ship, rand_num, :E)
        expect(subject.ships).to eq [rand_num, rand_num + 10, rand_num + 20]
      end

      it 'should place a ship facing south' do
        subject.place(ship, rand_num, :S)
        expect(subject.ships).to eq [rand_num, rand_num + 1, rand_num + 2]
      end

      it 'should place a ship facing west' do
        subject.place(ship, rand_num, :W)
        expect(subject.ships).to eq [rand_num, rand_num - 10, rand_num - 20]
      end

      it 'should not be sticking off the sides' do
        expect { subject.place(ship, 100, :E) }.to\
          raise_error 'Must be on the board'
      end
    end
  end

  describe '#fire' do
    before(:each) { allow(ship).to receive(:size) { rand(1..2) } }
    before(:each) { subject.place(ship, rand_num, :N) }
    it 'should respond to fire with 1 argument' do
      expect(subject).to respond_to(:fire).with(1).argument
    end

    it 'should retrun :hit when it hits' do
      expect(subject.fire(rand_num)).to eq :hit
    end

    it 'should return :miss when it misses' do
      expect(subject.fire(rand_num + 11)).to eq :miss
    end

    it 'should make the ship to receive got_hit when hit' do
      expect(ship).to receive(:got_hit)
      subject.fire(rand_num)
    end

    it 'should make the ship to receive got_hit when hit' do
      expect(ship).to_not receive(:got_hit)
      subject.fire(rand_num + 11)
    end

    it 'should not register two hits when we hit the same spot' do
      expect(ship).to receive(:got_hit)
      subject.fire(rand_num)
      expect(ship).to_not receive(:got_hit)
      subject.fire(rand_num)
    end

    it 'should log the hit(s)' do
      subject.fire(rand_num)
      expect(subject.hits).to eq [rand_num]
    end

    it 'should log the miss(es)' do
      subject.fire(rand_num + 11)
      expect(subject.misses).to eq [rand_num + 11]
    end
  end

  describe '#all_sunk?' do
    before(:each) { allow(ship).to receive(:size) { rand(1..2) } }
    before(:each) { subject.place(ship, rand_num, :N) }
    it 'should return true if all ships are sunk' do
      subject.fire(rand_num)
      subject.fire(rand_num - 1)
      expect(subject.all_sunk?).to eq true
    end

    it 'should return false if all ships are not sunk' do
      subject.fire(rand_num - 11)
      expect(subject.all_sunk?).to eq false
    end
  end
end
