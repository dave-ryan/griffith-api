require "rails_helper"

RSpec.describe "Gifts", type: :request do
  describe "GET /gifts with no users" do
    it "returns 401" do
      get "/gifts"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /gifts without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      get "/gifts"
      expect(response).to have_http_status(401)
    end
  end

  describe "GET /gifts without any gifts" do
    it "returns empty data" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("get", "/gifts", user)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.length).to eq 0
    end
  end

  describe "GET /gifts with good data" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:gift, 10)
      request_with_login("get", "/gifts", user)
      expect(response).to have_http_status(200)
    end

    it "returns my data" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:gift, 10)
      request_with_login("get", "/gifts", user)
      data = JSON.parse(response.body)
      puts data
      expect(data.length).to eq 10
    end
  end
end
