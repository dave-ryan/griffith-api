require "rails_helper"

RSpec.describe "Admins", type: :request do
  describe "PUT /admin/secret-santa-shuffle with no users" do
    it "returns 401" do
      put "/admin/secret-santa-shuffle"
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/secret-santa-shuffle without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      put "/admin/secret-santa-shuffle"
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/secret-santa-shuffle without admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("put", "/admin/secret-santa-shuffle", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/secret-santa-shuffle with admin" do
    it "shuffles all users' secret santa" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      request_with_login("put", "/admin/reboot", admin)
      expect(response).to have_http_status(200)

      admin = FactoryBot.create(:admin, family_id: 2, secret_santa_id: 99)
      request_with_login("put", "/admin/secret-santa-shuffle", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "Secret santas have been assigned!"

      request_with_login("get", "/users", admin)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.length).to eq 25
      data.each do |user|
        expect(user["secret_santa_id"]).to_not eq 1
      end
      expect(data[-1]["secret_santa_id"]).to_not eq 99
    end
  end
end
