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

  describe "PUT /admin/secret-santa-shuffle with admin but too many men in one family" do
    it "returns 406, can't be shuffled" do
      FactoryBot.create_list(:family, 3)
      FactoryBot.create_list(:user, 6, family_id: 1, santa_group: 1)
      FactoryBot.create_list(:user, 1, family_id: 1, santa_group: 2)
      FactoryBot.create_list(:user, 2, family_id: 2, santa_group: 1)
      FactoryBot.create_list(:user, 4, family_id: 2, santa_group: 2)
      FactoryBot.create_list(:user, 3, family_id: 3, santa_group: 1)
      FactoryBot.create_list(:user, 4, family_id: 3, santa_group: 2)
      admin = FactoryBot.create(:admin)
      request_with_login("put", "/admin/secret-santa-shuffle", admin)
      expect(response).to have_http_status(406)
      expect(JSON.parse(response.body)["errors"]).to eq ["Secret Santa Shuffling is not possible because one family has too many members"]
    end
  end

  describe "PUT /admin/secret-santa-shuffle with admin but too many women in one family" do
    it "returns 406, can't be shuffled" do
      FactoryBot.create_list(:family, 3)
      FactoryBot.create_list(:user, 10, family_id: 1, santa_group: 2)
      FactoryBot.create_list(:user, 2, family_id: 2, santa_group: 1)
      FactoryBot.create_list(:user, 4, family_id: 2, santa_group: 2)
      FactoryBot.create_list(:user, 3, family_id: 3, santa_group: 1)
      FactoryBot.create_list(:user, 4, family_id: 3, santa_group: 2)
      admin = FactoryBot.create(:admin)
      request_with_login("put", "/admin/secret-santa-shuffle", admin)
      expect(response).to have_http_status(406)
      expect(JSON.parse(response.body)["errors"]).to eq ["Secret Santa Shuffling is not possible because one family has too many members"]
    end
  end

  describe "PUT /admin/secret-santa-shuffle with admin and seeded data" do
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

      secret1 = []
      secret2 = []
      data.each do |user|
        if user["santa_group"]
          secret1 << user["id"]
          secret2 << user["secret_santa_id"]
        end
      end
      expect(secret1).to eq secret1.uniq
      expect(secret2).to eq secret2.uniq
      expect(data[-1]["secret_santa_id"]).to_not eq 99
    end
  end
end
