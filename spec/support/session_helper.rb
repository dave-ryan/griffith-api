module SessionHelper
  def login_as(user)
    post "/sessions", params: { name: user.name, password: user.password }
    expect(response).to have_http_status(:created)
    parsed = JSON.parse(response.body)

    return parsed["jwt"]
  end
end
