require 'rails_helper'

RSpec.describe "Matches", type: :request do
  describe "POST " do
    it "returns http failure" do
      post "/matches"
      expect(response).to have_http_status(422)
    end
  end
end
