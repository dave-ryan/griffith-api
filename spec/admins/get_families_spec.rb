require "rails_helper"

RSpec.describe "Admins", type: :request do
  describe "GET /admin/families with no families" do
    it "returns 401" do
      get "/admin/families"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /admin/families without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      get "/admin/families"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /admin/families without admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/admin/families", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /admin/families with no families" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("delete", "/families/1", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "Family destroyed!"
      request_with_login("get", "/admin/families", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq 0
    end
  end

  describe "GET /admin/families with families" do
    it "returns 200" do
      family = FactoryBot.create(:family)
      family2 = FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("get", "/admin/families", admin)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.length).to eq 2
      expect(data[0]["name"]).to eq family.name
      expect(data[0]["id"]).to eq family.id
      expect(data[1]["name"]).to eq family2.name
      expect(data[1]["id"]).to eq family2.id
    end
  end
end
