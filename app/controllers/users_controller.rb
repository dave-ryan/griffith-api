class UsersController < ApplicationController
  before_action :authenticate_admin, except: [:show]
  before_action :authenticate_user, only: [:show]

  def index
    users = User.all.includes(:gifts,
                              :purchasers,
                              :secret_santa,
                              :family,
                              :customgifts,
                              :customgift_purchasers).order(:name)
    render json: users,
           include: [
                      :secret_santa,
                      :family,
                      :santa_group,
                      :gifts => { include: :purchaser },
                      :customgifts => { include: :customgift_purchaser },
                    ]
  end

  def show
    render json: current_user, serializer: UserMinSerializer
  end

  def create
    permitted = params.permit(:name,
                              :family_id,
                              :is_admin,
                              :password,
                              :santa_group,
                              :secret_santa_id,
                              :password)
    user = User.new(name: permitted[:name],
                    family_id: permitted[:family_id],
                    password: permitted[:password],
                    secret_santa_id: permitted[:secret_santa_id],
                    santa_group: permitted[:santa_group])

    if user.save
      render json: { message: "User created successfully!" }
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if !user
      render json: {}, status: :unauthorized
    else
      permitted = params.permit(:name,
                                :family_id,
                                :is_admin,
                                :password,
                                :santa_group,
                                :secret_santa_id,
                                :password)
      permitted.each do |param, value|
        if user[param] != value
          if param == "password"
            user[:password_digest] = BCrypt::Password.create(params[:password].downcase)
          else
            user[param] = value
          end
        end
      end

      if user.save
        render json: { message: "User updated successfully!" }
      else
        render json: { errors: user.errors.full_messages }
      end
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    user.delete
    render json: { message: "User has been deleted!" }
  end
end
