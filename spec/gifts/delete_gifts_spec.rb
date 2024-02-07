require "rails_helper"

RSpec.describe "Gifts", type: :request do
  describe "DELETE /gifts/1 without logging in" do
    it "returns 401" do
      delete "/gifts/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /gifts/1 without any gifts" do
    it "returns 404" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)

      request_with_login("delete", "/gifts/1", user)
      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE /gifts/1 with the wrong user" do
    it "returns 401" do
      FactoryBot.create(:family)
      FactoryBot.create_list(:user, 10)
      FactoryBot.create_list(:gift, 10)
      user = FactoryBot.create(:user)

      request_with_login("delete", "/gifts/1", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /gifts/1 with gifts" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:gift, 10)

      request_with_login("delete", "/gifts/1", user)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq "Gift destroyed!"
    end
  end
end
