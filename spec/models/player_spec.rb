require 'rails_helper'

RSpec.describe Player, type: :model do
  before(:each) do
    @player = Player.new(first_name: 'Jonny', last_name: 'Jones', dob: '23-09-1987', nationality: 'British',
                     rating: '1500', matchesplayed: '4', rank: 'Novice', globalranking: '1')
  end
  context 'Format own data' do
    it 'will update the values to default start values upon being registered' do
      @player.format_json_updates
      expect(@player.rating).to eq(1200)
      expect(@player.rank).to eq('Unranked')
      expect(@player.matchesplayed).to eq(0)
    end
  end
end
