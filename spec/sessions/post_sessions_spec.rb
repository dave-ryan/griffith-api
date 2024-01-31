require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /sessions with no users or params " do
    it "returns 401" do
      post "/sessions"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /sessions with good params" do
    it "returns 201" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      post "/sessions", params: { name: user.name, password: user.password }
      expect(response).to have_http_status(201)
      data = JSON.parse(response.body)
    end
  end

  describe "POST /sessions with bad password" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      post "/sessions", params: { name: user.name, password: "wrong" }
      expect(response).to have_http_status(401)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq "Wrong password"
    end
  end

  describe "POST /sessions with no password" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      post "/sessions", params: { name: user.name }
      expect(response).to have_http_status(401)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq "No Name or Password Provided"
    end
  end

  describe "POST /sessions with no name" do
    it "returns 401" do
      FactoryBot.create(:family)
      user = FactoryBot.create(:user)
      post "/sessions", params: { password: user.password }
      expect(response).to have_http_status(401)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq "No Name or Password Provided"
    end
  end
end
