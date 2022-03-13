require 'spec_helper'
require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  describe 'POST /' do
    it 'should respond to a post request and will return error if no JSON given' do
      post :create
      expect(response).to have_http_status(422)
    end
  end
end