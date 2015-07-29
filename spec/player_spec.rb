require 'player'

describe Player do
	let(:ship){double :ship, size: 2}
	let(:board) {double :board}
	let(:player) {Player.new board}

	describe '#fire' do 
  	it 'responds to fire with 1 argument' do 
  		expect(player).to respond_to(:fire).with(1).argument
  	end 

  	it 'should call hit or miss in board' do 
  		allow(board).to receive(:hit_or_miss)
  		expect(board).to receive(:hit_or_miss) 
  		player.fire (:A1)
  	end 
  end
end 