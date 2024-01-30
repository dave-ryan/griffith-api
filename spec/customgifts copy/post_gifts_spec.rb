require "rails_helper"

RSpec.describe "Gifts", type: :request do
  describe "POST /gifts without logging in or params" do
    it "returns 401" do
      post "/gifts"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /gifts with no params" do
    it "returns 400" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("post", "/gifts", user)
      expect(response).to have_http_status(400)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq ["Name can't be blank"]
    end
  end

  describe "POST /gifts with min params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      params = { name: FFaker::Product.product }
      request_with_login("post", "/gifts", user, params)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /gifts with all params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      gift_name = FFaker::Product.product
      gift_link = FFaker::Internet.http_url
      params = { name: gift_name, link: gift_link }
      request_with_login("post", "/gifts", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["name"]).to eq gift_name
      expect(data["link"]).to eq gift_link
    end
  end
end
