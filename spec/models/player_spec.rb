require 'rails_helper'

RSpec.describe Player, type: :model do
  before(:each) do
    @player = Player.new(first_name: 'Jonny', last_name: 'Jones', dob: '23-09-1987', nationality: 'British',
                     rating: '1500', matchesplayed: '4', rank: 'Bronze', globalranking: '1')
  end
  context 'Format own data' do
    it 'will update the values to default start values upon being registered' do
      @player.format_json_updates
      expect(@player.rating).to eq(1200)
      expect(@player.rank).to eq('Unranked')
      expect(@player.matchesplayed).to eq(0)
    end

    it 'will format its own data and return it in an array in the correct format' do
      output = @player.player_format
      expect(output['age']).to eq(34)
      expect(output['full name']).to eq('Jonny Jones')
      expect(output['current position']).to eq(1)
      expect(output['nationality']).to eq('British')
      expect(output['rank name']).to eq('Bronze')
      expect(output['points']).to eq(1500)
    end
  end

  context 'Calculate Global Ranking' do
    it 'will recalculate its global rank and return i. j and its current rating' do
      @player.update("globalranking": 2)
      @player.change_player_global_ranking(0, 0, 0)
      expect(@player.globalranking).to eq(1)
      @player.change_player_global_ranking(1, 0, 1600)
      expect(@player.globalranking).to eq(2)
      @player.change_player_global_ranking(1, 1, 1600)
      expect(@player.globalranking).to eq(3)
      @player.change_player_global_ranking(1, 1, 1500)
      expect(@player.globalranking).to eq(1)
    end
  end

  context 'Calculate Player rank' do
    it 'will recalulate its rank to unranked if not enough matches played' do
      @player.update("matchesplayed": '1')
      @player.update("rank": 'Unranked')
      @player.recalculate_player_rank
      expect(@player.rank).to eq('Unranked')
    end

    it 'will recalulate its rank to the correct rank if over 3 matches played' do
      @player.update("rating": '500')
      @player.recalculate_player_rank
      expect(@player.rank).to eq('Bronze')
      @player.update("rating": '10001')
      @player.recalculate_player_rank
      expect(@player.rank).to eq('Supersonic Legend')
      @player.update("rating": '6000')
      @player.recalculate_player_rank
      expect(@player.rank).to eq('Gold')
      @player.update("rating": '4000')
      @player.recalculate_player_rank
      expect(@player.rank).to eq('Silver')
      @player.update("rating": '500')
      @player.recalculate_player_rank
      expect(@player.rank).to eq('Bronze')
    end
  end
end
