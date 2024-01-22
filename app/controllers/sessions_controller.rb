class SessionsController < ApplicationController
  def create
    user = User.where("LOWER(name) LIKE ?", params[:name].delete(" ").downcase).first
    if params[:password][-1] == " "
      password = params[:password][0..-2]
    else
      password = params[:password]
    end
    if !user
      render json: { errors: "Wrong username" }, status: :unauthorized
    elsif user && user.authenticate(password.downcase)
      jwt = JWT.encode(
        {
          user_id: user.id,
          exp: 30.days.from_now.to_i,
        },
        Rails.application.credentials.fetch(:secret_key_base),
        "HS256" # the encryption algorithm
      )
      render json: { jwt: jwt, user: ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer) }, status: :created
    else
      render json: { errors: "Wrong password" }, status: :unauthorized
    end
  end
end
