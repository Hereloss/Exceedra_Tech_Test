require 'rails_helper'

RSpec.describe "Players", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/players/index"
      expect(response).to have_http_status(:found)
    end
  end

  describe "POST /index" do
    it "returns http failure" do
      post "/players"
      expect(response).to have_http_status(422)
    end
  end

end
