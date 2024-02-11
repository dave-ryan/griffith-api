require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /current-user with no users" do
    it "returns 401" do
      get "/current-user"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /current-user without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      get "/current-user"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /current-user with good data" do
    it "returns my user record" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/current-user", user)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.length).to eq 7
      expect(data["family_id"]).to eq 1
      expect(data["santa_group"]).to eq 1
      expect(data["secret_santa_id"]).to eq 2
      expect(data["is_admin"]).to eq false
    end
  end
end
