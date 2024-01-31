require "rails_helper"

RSpec.describe "Families", type: :request do
  describe "DELETE /families/1 without logging in" do
    it "returns 401" do
      delete "/families/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /families/1 without non-admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("delete", "/families/1", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /families/2 with missing family" do
    it "returns 404" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin_user)
      request_with_login("delete", "/families/2", admin)
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["errors"]).to eq ["No family found"]
    end
  end

  describe "DELETE /families/1 as admin" do
    it "returns 200" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin_user)
      request_with_login("delete", "/families/1", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "Family destroyed!"
    end
  end
end
