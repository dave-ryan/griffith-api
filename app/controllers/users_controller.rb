class UsersController < ApplicationController
  before_action :authenticate_admin, except: [:show, :index, :generate_share_code, :friends, :create, :share]
  before_action :authenticate_user, only: [:show, :index, :generate_share_code, :friends]

  def index
    friends = current_user.friends

    if current_user.family
      users = User.includes(:secret_santa,
                            :gifts,
                            :purchasers,
                            :family,
                            :customgifts,
                            :customgift_purchasers).where.not(family_id: nil).order(:name)
      render json: users + friends,
            include: [
                        "secret_santa",
                        "gifts",
                        "gifts.purchaser",
                        "customgifts",
                        "customgifts.customgift_purchaser",
                      ]
    else
      render json: friends, status: 200
    end
  end

  def show
    render json: current_user, serializer: UserMinSerializer
  end

  def share
    user = User.includes(:secret_santa,
                          :gifts,
                          :purchasers,
                          :family,
                          :customgifts,
                          :customgift_purchasers).find_by(id: params[:id])
    if user && params[:share_code] == user.share_code
      render json: user,
      include: [
                 "secret_santa",
                 "gifts",
                 "gifts.purchaser",
                 "customgifts",
                 "customgifts.customgift_purchaser",
               ]
    else
      render json: { message: "Wrong Code or User!" }, status: 401
    end
  end

  def create
    duplicate_user = User.where("lower(name) = ?", params[:name].downcase).first
    if duplicate_user
      render json: {errors: ["User with that name already exists"]}, status: 409
    else
      permitted = params.permit(:name,
                                :family_id,
                                :is_admin,
                                :password,
                                :santa_group,
                                :secret_santa_id,
                                :birthday)
      user = User.new(name: permitted[:name],
                      family_id: permitted[:family_id] || nil,
                      is_admin: permitted[:is_admin] || nil,
                      santa_group: permitted[:santa_group] || nil,
                      secret_santa_id: permitted[:secret_santa_id] || nil,
                      birthday: permitted[:birthday] || nil,
                      password: permitted[:password],
                      share_code: SecureRandom.hex(5))
      if user.save!
        render json: { message: "User created successfully!" }
      else
        render json: { errors: user.errors.full_messages }, status: 400
      end
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
                                :santa_group,
                                :secret_santa_id,
                                :birthday,
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

  def generate_share_code
    current_user.share_code = SecureRandom.hex(5)
    if current_user.save
      render json: current_user
    else
      render json: { errors: current_user.errors.full_messages }
    end
  end
end
