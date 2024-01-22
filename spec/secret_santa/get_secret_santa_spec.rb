require "rails_helper"

RSpec.describe "Secret Santa", type: :request do
  describe "GET /secret-santa with no users" do
    it "returns 401" do
      get "/secret-santa"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /secret-santa without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      get "/secret-santa"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /secret-santa with no secret santa" do
    it "returns 400" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/secret-santa", user)
      expect(response).to have_http_status(400)
    end
  end

  describe "GET /secret-santa with good data" do
    it "returns 200" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 5)
      user = FactoryBot.create(:user)
      request_with_login("get", "/secret-santa", user)
      expect(response).to have_http_status(200)
    end

    it "returns my data" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 5)
      user = FactoryBot.create(:user)
      request_with_login("get", "/secret-santa", user)
      data = JSON.parse(response.body)
      expect(data.length).to eq 8
      expect(data["santa_group"]).to eq 1
      expect(data["secret_santa_id"]).to eq 2
      expect(data["is_admin"]).to eq false
    end
  end
end
