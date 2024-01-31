require "rails_helper"

RSpec.describe "Families", type: :request do
  describe "POST /families without logging in or params" do
    it "returns 401" do
      post "/families"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /families with non-admin, no params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("post", "/families", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /families with non-admin, with params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      params = { name: FFaker::Name.last_name }
      request_with_login("post", "/families", user, params)
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /families with admin, without params" do
    it "returns 400" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("post", "/families", admin)
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["errors"]).to eq ["Name can't be blank"]
    end
  end

  describe "POST /families with admin, with bad params" do
    it "returns 400" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: "" }
      request_with_login("post", "/families", admin, params)
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["errors"]).to eq ["Name can't be blank"]
    end
  end

  describe "POST /families with admin, with params" do
    it "returns 200" do
      family = FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: FFaker::Name.last_name }
      request_with_login("post", "/families", admin, params)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["name"]).to eq params[:name]
      expect(JSON.parse(response.body)["users"].length).to eq 0
      expect(JSON.parse(response.body)["secret_santas"].length).to eq 0
      expect(JSON.parse(response.body)["gifts"].length).to eq 0
      expect(JSON.parse(response.body)["purchasers"].length).to eq 0
      expect(JSON.parse(response.body)["customgifts"].length).to eq 0
      expect(JSON.parse(response.body)["customgift_purchasers"].length).to eq 0
    end
  end
end
