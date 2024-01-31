require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "DELETE /users/1 without logging in" do
    it "returns 401" do
      delete "/users/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /users/1 with non-admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("delete", "/users/1", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /users/1 with admin" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("delete", "/users/1", admin)
      expect(response).to have_http_status(200)
    end
  end
end
