require 'ships'

describe Ship do
	let(:ship) {Ship.patrol_boat}

	describe 'size' do 
		it 'should have a size of 2 when created' do 
			expect(ship.size).to eq 2
		end 

		it 'should be able to change' do 
			expect(ship)
		end 
	end 

	describe 'hits' do 
		it 'should start with 0 hits' do 
			expect(ship.hits).to eq 0
		end 
	end 

	describe '#got_hit' do 
		it 'should respond to got hit' do
			expect(ship).to respond_to(:got_hit)	
		end

		it 'should count the number of hits' do 
			ship.got_hit
			expect(ship.hits).to eq 1
		end  
	end 

	describe '#sunk?' do 
		it 'should be sunk when it has hits equal to its size' do 
			ship.size.times { ship.got_hit}
			expect(ship.sunk?).to eq true
		end 

		it 'should not be sunk when it has hits less to its size' do 
			(ship.size - 1).times {ship.got_hit}
			expect(ship.sunk?).to eq false
		end 
	end 
end 