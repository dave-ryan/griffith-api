require "rails_helper"

RSpec.describe "Gifts", type: :request do
  describe "PATCH /gifts/1 without logging in or params" do
    it "returns 401" do
      patch "/gifts/1"
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /gifts/1 no gifts" do
    it "returns 400" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)

      request_with_login("patch", "/gifts/1", user)
      expect(response).to have_http_status(400)
    end
  end

  describe "PATCH /gifts/1 with purchasing params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { purchasing: "purchasing" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id
    end
  end

  describe "PATCH /gifts/1 with purchasing params and I already purchased" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { purchasing: "purchasing" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id
    end
  end

  describe "PATCH /gifts/1 with purchasing params and someone else purchased" do
    it "returns 400" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { purchasing: "purchasing" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id

      user2 = FactoryBot.create(:user)
      request_with_login("patch", "/gifts/1", user2, params)
      expect(response).to have_http_status(400)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq "Someone already purchased this gift!"
    end
  end

  describe "PATCH /gifts/1 with un-purchasing params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { purchasing: "purchasing" }

      request_with_login("patch", "/gifts/1", user, params)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id

      params2 = { purchasing: "unpurchasing" }

      request_with_login("patch", "/gifts/1", user, params2)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq nil
    end
  end

  describe "PATCH /gifts/1 with un-purchasing params but gift doesn't have purchaser" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { purchasing: "unpurchasing" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq nil
    end
  end

  describe "PATCH /gifts/1 with un-purchasing params but gift has a purchaser that's not me" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { purchasing: "purchasing" }

      request_with_login("patch", "/gifts/1", user, params)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id

      user2 = FactoryBot.create(:user)
      params2 = { purchasing: "unpurchasing" }

      request_with_login("patch", "/gifts/1", user2, params2)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["purchaser_id"]).to eq user.id
    end
  end

  describe "PATCH /gifts/1 with name params but wrong user" do
    it "returns 401" do
      FactoryBot.create(:family)
      FactoryBot.create(:user)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { name: "Test" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /gifts/1 with name params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { name: "Test" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["name"]).to eq "Test"
    end
  end

  describe "PATCH /gifts/1 with link params" do
    it "returns 200" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)
      params = { link: "Test" }

      request_with_login("patch", "/gifts/1", user, params)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["link"]).to eq "Test"
    end
  end
end
