require 'spec_helper'
require 'rails_helper'

RSpec.describe PlayersController, type: :controller do

  describe 'GET /players' do

    it 'will respond with JSON of all players if no params given' do
      get :index
      expect(response).to have_http_status(204) 
    end

  end

end