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

    it 'will register a player if no error raised and return JSON' do
      post :create,
           params: { player_details: { first_name: 'Jonny', last_name: 'Jones', dob: '23-12-1996',
                                     nationality: 'Bobonite' } }
      expect(response).to have_http_status(201)
      expect(response.body).to include('Jonny', 'Jones', '23-12-1996', 'Bobonite')
    end

  end

end