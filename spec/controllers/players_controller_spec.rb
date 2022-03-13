# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  describe 'GET /players' do
    before(:each) do
      Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1977', nationality: 'Scottish', points: '800',
                    matchesplayed: '0', rank: 'Unranked', globalranking: '2')
      Player.create(first_name: 'Jonny', last_name: 'Jones', dob: '23-09-1987', nationality: 'British', points: '1500',
                    matchesplayed: '4', rank: 'Bronze', globalranking: '1')
    end

    it 'will respond with JSON of all players if no params given' do
      get :index
      expect(response).to have_http_status(302)
      expect(response.body).to eq('[{"current position":1,"full name":"Jonny Jones","age":34,"nationality":"British","rank name":"Bronze","points":1500},{"current position":2,"full name":"John Jones","age":44,"nationality":"Scottish","rank name":"Unranked","points":800}]')
    end

    it 'will return filtered by rank if search type is rank' do
      get :index, params: { search_type: 'rank', rank: 'Unranked' }
      expect(response.body).to eq('[{"current position":2,"full name":"John Jones","age":44,"nationality":"Scottish","rank name":"Unranked","points":800}]')
    end

    it 'will return filtered by nationality if search type is nationality' do
      get :index, params: { search_type: 'nationality', nationality: 'Welsh' }
      expect(response.body).not_to include('John', 'Jonny', 'Jones', 'Scottish',
                                           'British', '800', '1500', 'Unranked', 'Bronze', '1', '2')
      get :index, params: { search_type: 'nationality', nationality: 'Scottish' }
      expect(response.body).to eq('[{"current position":2,"full name":"John Jones","age":44,"nationality":"Scottish","rank name":"Unranked","points":800}]')
    end

    it 'will return all players if search type is none of these' do
      get :index, params: { search_type: 'job' }
      expect(response.body).to eq('[{"current position":1,"full name":"Jonny Jones","age":34,"nationality":"British","rank name":"Bronze","points":1500},{"current position":2,"full name":"John Jones","age":44,"nationality":"Scottish","rank name":"Unranked","points":800}]')
    end

    it 'will sort the players into the correct order and present them in point order, unranked at the bottom' do
      Player.create(first_name: 'John', last_name: 'Bobson', dob: '23-09-1977', nationality: 'Scottish', points: '1000',
                    matchesplayed: '3', rank: 'Bronze', globalranking: '3')
      Player.create(first_name: 'Jonny', last_name: 'Bobson', dob: '23-09-1987', nationality: 'British', points: '1900',
                    matchesplayed: '4', rank: 'Bronze', globalranking: '4')
      Player.create(first_name: 'Jonny', last_name: 'Bobson', dob: '23-09-1987', nationality: 'British', points: '1900',
                    matchesplayed: '0', rank: 'Unranked', globalranking: '4')
      get :index
      expect(response.body).to eq('[{"current position":1,"full name":"Jonny Bobson","age":34,"nationality":"British","rank name":"Bronze","points":1900},{"current position":3,"full name":"Jonny Jones","age":34,"nationality":"British","rank name":"Bronze","points":1500},{"current position":4,"full name":"John Bobson","age":44,"nationality":"Scottish","rank name":"Bronze","points":1000},{"current position":1,"full name":"Jonny Bobson","age":34,"nationality":"British","rank name":"Unranked","points":1900},{"current position":5,"full name":"John Jones","age":44,"nationality":"Scottish","rank name":"Unranked","points":800}]')
    end
  end

  describe 'POST /players' do
    it 'should respond to a post request and will return error if no JSON given' do
      post :create
      expect(response).to have_http_status(422)
      expect(response.body).to include('Blank JSON sent')
    end

    it 'will return error if JSON is in wrong format or incomplete' do
      post :create, params: { player_details: { first_name: 'bob' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
      post :create, params: { player_details: { last_name: 'bob' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
      post :create, params: { player_details: { first_name: 'bob', last_name: 'bob' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
      post :create, params: { player_details: { first_name: 'bob', last_name: 'bob', dob: '23-12-1996' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
      post :create,
           params: { player_details: { first_name: 'bob', last_name: 'bob', dob: '23-92-1996',
                                       nationality: 'Bobonite' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
      post :create, params: { player_details: { first_name: 'bob', last_name: 'bob', nationality: 'Bobonite' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
      post :create, params: { player_details: { first_name: '', last_name: '', nationality: '', dob: '23-12-1996' } }
      expect(response).to have_http_status(422)
      expect(response.body).to include('Missing or incorrect sign up information;')
    end

    it 'will return specific error if registering player with same name already registered' do
      Player.create(first_name: 'Jonny', last_name: 'Jones', dob: '23-09-1987', nationality: 'British', points: '1500',
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
      expect(response.body).to eq('{"current position":1,"full name":"Jonny Jones","age":25,"nationality":"Bobonite","rank name":"Unranked","points":1200}')
    end

    it 'will register a player and set their values to default even if given' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996', nationality: 'Bob',
                                       points: '1200', rank: 'Gold' } }
      expect(response).to have_http_status(201)
      expect(response.body).to eq('{"current position":1,"full name":"Jonny Jones","age":25,"nationality":"Bob","rank name":"Unranked","points":1200}')
    end

    it 'will return the correctly formatted JSON after registering' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996',
                                       nationality: 'Bobonite' } }
      expect(response).to have_http_status(201)
      expect(response.body).to eq('{"current position":1,"full name":"Jonny Jones","age":25,"nationality":"Bobonite","rank name":"Unranked","points":1200}')
    end
  end

  describe 'global ranking re-order feature test' do
    it 'will make the global rankings re-order correctly by sending correct information' do
      Player.create(first_name: 'John', last_name: 'Jones', dob: '23-09-1977', nationality: 'Scottish',
                    points: '800', matchesplayed: '0', rank: 'Unranked', globalranking: '1')
      Player.create(first_name: 'Jonny', last_name: 'Jones', dob: '23-09-1987', nationality: 'British',
                    points: '1500', matchesplayed: '4', rank: 'Unranked', globalranking: '2')
      PlayersController.recalculate_global_rankings
      expect(Player.find(1).globalranking).to eq(2)
      expect(Player.find(2).globalranking).to eq(1)
      expect(Player.find(2).rank).to eq('Bronze')
    end
  end
end
