require 'rails_helper'

RSpec.describe Match, type: :model do
  before(:each) do
    @match = Match.new({ winner_id: '1', winner_name: 'John Jones', loser_id: '2', loser_name: 'Joan Johnson' })
    @winner = Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1987', nationality: 'Scottish',
                            rating: '800', matchesplayed: '0', globalranking: '1', rank: 'Unranked')
      @loser = Player.create(first_name: 'Joan', last_name: 'Johnson', dob: '23-09-1987', nationality: 'Scottish',
                           rating: '800', matchesplayed: '4', globalranking: '1', rank: 'None')
  end

  context 'formats match data' do
    it 'will format the match data correctly upon being asked' do
   
      expect(@match.format_match(winner.id,
                                 loser.id)).to eq({"match ID"=>nil, "winner name"=>"John Jones", "loser name"=>"Joan Johnson", "winner rating"=>880, "winner rank"=>"Unranked", "winner global ranking"=>"1", "loser rating"=>720, "loser rank"=>"None", "loser global ranking"=>"2", "played at"=>nil})
    end
  end

  context 'asks players to update scores' do
    it 'the scores will be updated' do
      @match.update_player_scores(@winner, @loser)
      expect(@winner.rating).to eq(880)
      expect(@loser.rating).to eq(720)
    end
  end
end
