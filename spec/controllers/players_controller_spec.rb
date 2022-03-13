require 'spec_helper'
require 'rails_helper'

RSpec.describe PlayersController, type: :controller do

  describe 'GET /players' do

    it 'will respond with JSON of all players if no params given' do
      get :index
      expect(response).to have_http_status(204) 
    end

  end

  describe 'POST /' do
    it 'should respond to a post request and will return error if no JSON given' do
      post :create
      expect(response).to have_http_status(422)
    end

    it 'will return error if JSON is in wrong format or incomplete' do
      post :create, params: { player_details: { first_name: 'bob' } }
      expect(response).to have_http_status(422)
      post :create, params: { player_details: { last_name: 'bob' } }
      expect(response).to have_http_status(422)
      post :create, params: { player_details: { first_name: 'bob', last_name: 'bob' } }
      expect(response).to have_http_status(422)
      post :create, params: { player_details: { first_name: 'bob', last_name: 'bob', dob: '23-12-1996' } }
      expect(response).to have_http_status(422)
      post :create,
           params: { player_details: { first_name: 'bob', last_name: 'bob', dob: '23-92-1996', nationality: 'Bobonite' } }
      expect(response).to have_http_status(422)
      post :create, params: { player_details: { first_name: 'bob', last_name: 'bob', nationality: 'Bobonite' } }
      expect(response).to have_http_status(422)
      post :create, params: { player_details: { first_name: '', last_name: '', nationality: '', dob: '23-12-1996' } }
      expect(response).to have_http_status(422)
    end

    it 'will return specific error if registering player with same name already registered' do
      Player.create(first_name: 'Jonny', last_name: 'Jones', dob: '23-09-1987', nationality: 'British', rating: '1500',
                  matchesplayed: '4', rank: 'Novice', globalranking: '1')
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996',
                                     nationality: 'Bobonite' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Name is already taken')
    end

    it 'will return specific error if registering player under age of 16' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-2016',
                                     nationality: 'Bobonite' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Under age limit')
    end

    it 'will register a player if no error raised' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996',
                                     nationality: 'Bobonite' } }
      expect(response).to have_http_status(201)
      expect(response.body).to include('Jonny', 'Jones', '25', 'Bobonite')
    end

    it 'will register a player and set their values to default even if given' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996', nationality: 'Bob',
                                     rating: '1200', rank: 'Gold' } }
      expect(response).to have_http_status(201)
      expect(response.body).to include('Jonny', 'Jones', 'Bob', '1200', 'Unranked','25')
    end

    it 'will return the correctly formatted JSON after registering' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996',
                                     nationality: 'Bobonite' } }
      expect(response).to have_http_status(201)
      p response.body
      expect(response.body).to eq("{\"current position\":null,\"full name\":\"Jonny Jones\",\"age\":25,\"nationality\":\"Bobonite\",\"rank name\":\"Unranked\",\"points\":1200}")
    end

  end

end