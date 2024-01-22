require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users with no users" do
    it "returns 401" do
      get "/users"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /users with non-admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/users", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /users with admin" do
    it "returns status code 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin_user)
      request_with_login("get", "/users", admin)
      expect(response).to have_http_status(200)
    end

    it "returns full list of users" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 9)
      admin = FactoryBot.create(:admin_user)
      request_with_login("get", "/users", admin)
      expect(JSON.parse(response.body).length).to eq 10
    end
  end
end
