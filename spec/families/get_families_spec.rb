require "rails_helper"

RSpec.describe "Families", type: :request do
  describe "GET /families with no users" do
    it "returns 401" do
      get "/families"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /families without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      get "/families"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /families with missing data" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("delete", "/families/1", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "Family destroyed!"
      request_with_login("get", "/families", admin)
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["errors"]).to eq ["No family found"]
    end
  end

  describe "GET /families with good data" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/families", user)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /families and return only my family" do
    it "returns 200" do
      my_family = FactoryBot.create(:family)
      FactoryBot.create_list(:family, 3)
      user = FactoryBot.create(:user)
      request_with_login("get", "/families", user)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["name"]).to eq my_family.name
      expect(data["id"]).to eq my_family.id
      expect(data["users"].length).to eq 1
    end
  end
end
