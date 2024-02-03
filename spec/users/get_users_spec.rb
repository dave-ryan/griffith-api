require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users with no users" do
    it "returns 401" do
      get "/users"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /users with non-admin" do
    it "returns full list of users" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 9)
      user = FactoryBot.create(:user)
      request_with_login("get", "/users", user)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq 10
    end
  end

  describe "GET /users with admin" do
    it "returns full list of users" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 9)
      admin = FactoryBot.create(:admin)
      request_with_login("get", "/users", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq 10
    end
  end
end
