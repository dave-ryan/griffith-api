require "rails_helper"

RSpec.describe "Customgifts", type: :request do
  describe "PATCH /customgifts/1 without logging in or params" do
    it "returns 401" do
      patch "/customgifts/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /customgifts/1 with no params and invalid customgift id" do
    it "returns 404" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("patch", "/customgifts/1", user)
      expect(response).to have_http_status(404)
    end
  end

  describe "PATCH /customgifts/1 with params but invalid customgift id" do
    it "returns 404" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:customgift)
      params = { note: "Test" }
      request_with_login("patch", "/customgifts/100", user, params)
      expect(response).to have_http_status(404)
    end
  end

  describe "PATCH /customgifts/1 with params but wrong user" do
    it "returns 401" do
      FactoryBot.create(:family)
      FactoryBot.create(:user)
      user = FactoryBot.create(:user)
      FactoryBot.create(:customgift)
      params = { note: "Test" }
      request_with_login("patch", "/customgifts/1", user, params)
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /customgifts/1 with params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:customgift)
      params = { note: "Test" }
      request_with_login("patch", "/customgifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["note"]).to eq "Test"
    end
  end
end
