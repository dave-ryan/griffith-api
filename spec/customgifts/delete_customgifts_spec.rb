require "rails_helper"

RSpec.describe "Customgifts", type: :request do
  describe "DELETE /customgifts/1 without logging in" do
    it "returns 401" do
      delete "/customgifts/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /customgifts/1 without any customgifts" do
    it "returns 404" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("delete", "/customgifts/1", user)
      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE /customgifts/1 with the wrong user" do
    it "returns 401" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 10)
      FactoryBot.create_list(:customgift, 10)
      user = FactoryBot.create(:user)
      request_with_login("delete", "/customgifts/1", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /customgifts/1 with customgifts" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:customgift, 10)
      request_with_login("delete", "/customgifts/1", user)
      expect(response).to have_http_status(200)
    end
  end
end
