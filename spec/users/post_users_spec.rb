require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users without logging in or params" do
    it "returns 401" do
      post "/users"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /users with non-admin, no params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("post", "/users", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /users with non-admin, with params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      params = { name: FFaker::Name.first_name, family_id: 1, santa_group: 1, secret_santa: 1, is_admin: false, password: "123" }
      request_with_login("post", "/users", user, params)
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /users with admin, without params" do
    it "returns 400" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("post", "/users", admin)
      expect(response).to have_http_status(400)
    end
  end

  describe "POST /users with admin, without all required params" do
    it "returns 400" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { family_id: 1, santa_group: 1, secret_santa: 1, is_admin: false, password: "123" }
      request_with_login("post", "/users", admin, params)
      expect(response).to have_http_status(400)
    end
  end

  describe "POST /users with admin, with minimum required params" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: FFaker::Name.first_name, family_id: 1, password: "123" }
      request_with_login("post", "/users", admin, params)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users with admin, with required params" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      params = { name: FFaker::Name.first_name, family_id: 1, santa_group: 1, secret_santa: 1, is_admin: false, password: "123" }
      request_with_login("post", "/users", admin, params)
      expect(response).to have_http_status(200)
    end
  end
end
