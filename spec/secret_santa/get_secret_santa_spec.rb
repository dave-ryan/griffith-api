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
      FactoryBot.create(:user)
      get "/secret-santa"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /secret-santa with no santa group" do
    it "returns 200, empty data" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user, santa_group: nil)
      request_with_login("get", "/secret-santa", user)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.empty?).to be true
    end
  end

  describe "GET /secret-santa with missing secret santa (id = 2)" do
    it "returns 404" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/secret-santa", user)
      data = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(data["message"]).to eq "Missing Secret Santa!"
    end
  end

  describe "GET /secret-santa with good data" do
    it "returns 200" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 5)
      user = FactoryBot.create(:user)
      request_with_login("get", "/secret-santa", user)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.length).to eq 9
      expect(data["santa_group"]).to eq 1
      expect(data["secret_santa_id"]).to eq 2
      expect(data["is_admin"]).to eq false
    end
  end
end
