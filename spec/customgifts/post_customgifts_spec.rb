require "rails_helper"

RSpec.describe "Customgifts", type: :request do
  describe "POST /customgifts without logging in or params" do
    it "returns 401" do
      post "/customgifts"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /customgifts with no params" do
    it "returns 400" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      request_with_login("post", "/customgifts", user)
      expect(response).to have_http_status(400)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq ["User must exist", "Note can't be blank", "User can't be blank"]
    end
  end

  describe "POST /customgifts with too few params" do
    it "returns 400" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      params = { user_id: 1 }
      request_with_login("post", "/customgifts", user, params)
      expect(response).to have_http_status(400)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq ["Note can't be blank"]
    end
  end

  describe "POST /customgifts with all params" do
    it "returns 200" do
      FactoryBot.create(:family)
      FactoryBot.create(:user)
      user = FactoryBot.create(:user)
      gift_note = FFaker::Product.product
      user_id = 1
      params = { note: gift_note, user_id: user_id }
      request_with_login("post", "/customgifts", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["note"]).to eq gift_note
      expect(data["user_id"]).to eq user_id
      expect(data["customgift_purchaser_id"]).to eq user.id
    end
  end
end
