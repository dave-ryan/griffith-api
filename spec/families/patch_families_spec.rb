require "rails_helper"

RSpec.describe "Families", type: :request do
  describe "PATCH /families/1 without logging in or params" do
    it "returns 401" do
      patch "/families/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /families/1 with non-admin, no params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("patch", "/families/1", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /families/1 with non-admin, with params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      params = { name: FFaker::Name.last_name }
      request_with_login("patch", "/families/1", user, params)
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /families/1 with admin, without params" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("patch", "/families/1", admin)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /families/1 with admin, with params" do
    it "returns 200" do
      family = FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: "Test123" }
      request_with_login("patch", "/families/1", admin, params)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["name"]).to eq "Test123"
      expect(JSON.parse(response.body)["name"]).not_to eq family.name
    end
  end

  describe "PATCH /families/1 with admin, with bad params" do
    it "returns 400" do
      family = FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: "" }
      request_with_login("patch", "/families/1", admin, params)
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["errors"]).to eq ["Name can't be blank"]
    end
  end

  describe "PATCH /families/1 with admin, with params, missing family" do
    it "returns 404" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: FFaker::Name.last_name }
      request_with_login("patch", "/families/2", admin, params)
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["errors"]).to eq ["No family found"]
    end
  end
end
