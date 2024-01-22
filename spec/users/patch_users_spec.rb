require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "PATCH /users/1 without logging in or params" do
    it "returns 401" do
      patch "/users/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /users/1 with non-admin, no params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("patch", "/users/1", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /users/1 with non-admin, with params" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      params = { id: 1, name: FFaker::Name.first_name, family_id: 1, santa_group: 1, secret_santa: 1, is_admin: false, password: "123" }
      request_with_login("patch", "/users/1", user, params)
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /users/1 with admin, without params" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin_user)
      request_with_login("patch", "/users/1", admin)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /users/1 with admin, with required params" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin_user)
      params = { id: 1, name: FFaker::Name.first_name, family_id: 1, santa_group: 1, secret_santa: 1, is_admin: false, password: "123" }
      request_with_login("patch", "/users/1", admin, params)
      expect(response).to have_http_status(200)
    end
  end
end
