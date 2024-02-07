require "rails_helper"

RSpec.describe "Admin", type: :request do
  describe "PUT /admin/gifts-cleanup with no data" do
    it "returns 401" do
      put "/admin/gifts-cleanup"
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/gifts-cleanup with data without logging in" do
    it "returns 401" do
      FactoryBot.create(:family)
      FactoryBot.create(:user)
      FactoryBot.create(:gift)
      put "/admin/gifts-cleanup"
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/gifts-cleanup with data & non-admin" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      FactoryBot.create(:gift)

      request_with_login("put", "/admin/gifts-cleanup", user)
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /admin/gifts-cleanup with data & admin" do
    it "deletes all gifts that were purchased last year" do
      FactoryBot.create(:family)
      admin = FactoryBot.create(:admin)
      FactoryBot.create_list(:user, 4)
      old_date = Date.new(Date.today.year - 1, 11, 25)
      FactoryBot.create_list(:gift, 2, created_at: old_date, updated_at: old_date, purchaser_id: 3)
      FactoryBot.create_list(:gift, 3, purchaser_id: 3)

      request_with_login("put", "/admin/gifts-cleanup", admin)
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["message"]).to eq "Clean up Successful"
      expect(data["cleaned_up"].length).to eq 2

      request_with_login("get", "/gifts", admin)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq 3
    end
  end
end
