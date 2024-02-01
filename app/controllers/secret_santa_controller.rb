class SecretSantaController < ApplicationController
  before_action :authenticate_user

  def index
    secret_santa = @current_user.secret_santa
    if secret_santa
      my_secret_santa = User.includes(:gifts,
                                      :purchasers,
                                      :secret_santa,
                                      :family,
                                      :customgifts,
                                      :customgift_purchasers).find_by(id: secret_santa.id)
      render json: my_secret_santa,
             include: [
               :secret_santa,
               :santa_group,
               :gifts => { include: :purchaser },
               :customgifts => { include: :customgift_purchaser },
             ]
    elsif !@current_user.santa_group
      render json: {}
    else
      render json: { message: "Missing Secret Santa!" }, status: 404
    end
  end
end
