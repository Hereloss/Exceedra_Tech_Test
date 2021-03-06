# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  describe 'POST /' do
    it 'should respond to a post request and will return error if no JSON given' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'will return error if JSON is in wrong format or incomplete' do
      post :create, params: { match_details: { winner_name: 'bill' } }
      expect(response).to have_http_status(422)
      post :create, params: { match_details: { loser_name: 'bill' } }
      expect(response).to have_http_status(422)
    end

    it 'will return error if either player in JSON is not registered' do
      post :create,
           params: { match_details: { winner_id: '1', winner_name: 'bill j', loser_id: '2', loser_name: 'pete g' } }
      expect(response).to have_http_status(422)
    end

    it 'will return error if either player id doesnt match player' do
      Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1987', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      Player.create(first_name: 'Joan', last_name: 'Johnson', dob: '23-09-1987', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      post :create,
           params: { match_details: { winner_id: '1', winner_name: 'Joan Johnson', loser_id: '2',
                                      loser_name: 'John Jones' } }
      expect(response).to have_http_status(422)
      post :create,
           params: { match_details: { winner_id: '1', winner_name: 'Joan Johnson', loser_id: '1',
                                      loser_name: 'John Jones' } }
      expect(response).to have_http_status(422)
    end

    it 'will record match and update scores if both players registered' do
      Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1987', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      Player.create(first_name: 'Joan', last_name: 'Johnson', dob: '23-09-1987', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      post :create,
           params: { match_details: { winner_id: 1, winner_name: 'John Jones', loser_id: 2,
                                      loser_name: 'Joan Johnson' } }
      expect(response).to have_http_status(201)
      expect(Player.find(1).points).to eq(880)
      expect(Player.find(2).points).to eq(720)
    end

    it 'will return the results in the correct format' do
      Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1987', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      Player.create(first_name: 'Joan', last_name: 'Johnson', dob: '23-09-1987', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      post :create,
           params: { match_details: { winner_id: 1, winner_name: 'John Jones', loser_id: 2,
                                      loser_name: 'Joan Johnson' } }
      expect(response.body).to include('{"match ID":1,"winner name":"John Jones","loser name":"Joan Johnson","winner points":880,"winner rank":"Unranked","winner global ranking":1,"loser points":720,"loser rank":"Unranked","loser global ranking":2,"')
    end
  end
end
