require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /me with no users" do
    it "returns 401" do
      get "/me"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /me without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      get "/me"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /me with good data" do
    it "returns status code 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/me", user)
      expect(response).to have_http_status(200)
    end

    it "returns my data" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/me", user)
      data = JSON.parse(response.body)
      expect(data.length).to eq 6
      expect(data["family_id"]).to eq 1
      expect(data["santa_group"]).to eq 1
      expect(data["secret_santa_id"]).to eq 2
      expect(data["is_admin"]).to eq false
    end
  end
end
