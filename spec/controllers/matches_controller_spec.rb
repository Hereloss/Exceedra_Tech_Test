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
  end
end