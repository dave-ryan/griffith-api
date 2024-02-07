require "rails_helper"

RSpec.describe "Admin", type: :request do
  describe "PUT /admin/reboot with no users" do
    it "reseeds all data" do
      put "/admin/reboot"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "All users and their data have been destroyed and rebuilt"

      user = FactoryBot.create(:user)
      request_with_login("get", "/users", user)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq 25
    end
  end

  describe "PUT /admin/reboot with users without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      FactoryBot.create(:user)
      put "/admin/reboot"
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/reboot with users & non-admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("put", "/admin/reboot", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/reboot with users & admin" do
    it "reseeds all data" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 2)
      admin = FactoryBot.create(:admin)
      request_with_login("put", "/admin/reboot", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "All users and their data have been destroyed and rebuilt"

      user = FactoryBot.create(:user, family_id: 2)
      request_with_login("get", "/users", user)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq 25
    end
  end
end
