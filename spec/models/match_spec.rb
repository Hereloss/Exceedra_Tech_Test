require 'rails_helper'

RSpec.describe Match, type: :model do
  before(:each) do
    @match = Match.new({ winner_id: '1', winner_name: 'John Jones', loser_id: '2', loser_name: 'Joan Johnson' })
  end
  context 'asks players to update scores' do
    before(:each) do
      @winner = Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1987', nationality: 'Scottish',
                            rating: '800', matchesplayed: '0', globalranking: '1', rank: 'Unranked')
      @loser = Player.create(first_name: 'Joan', last_name: 'Johnson', dob: '23-09-1987', nationality: 'Scottish',
                           rating: '800', matchesplayed: '4', globalranking: '1', rank: 'None')
    end
    it 'the scores will be updated' do
      @match.update_player_scores(@winner, @loser)
      expect(@winner.rating).to eq(880)
      expect(@loser.rating).to eq(720)
    end
  end
end
