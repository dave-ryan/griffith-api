module RequestsHelper
  def request_with_login(request, path, user, params = {}, headers = {})
    headers.merge!("Authorization" => "Bearer #{login_as(user)}")
    send(request, path, params: params, headers: headers)
  end
end
