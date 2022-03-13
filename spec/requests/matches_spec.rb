require 'rails_helper'

RSpec.describe "Matches", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/matches/index"
      expect(response).to have_http_status(:success)
    end
  end

end
