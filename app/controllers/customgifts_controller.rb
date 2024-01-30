class CustomgiftsController < ApplicationController
  before_action :authenticate_user

  def create
    customgift = Customgift.new(
      user_id: params[:user_id],
      customgift_purchaser_id: @current_user.id,
      note: params[:note],
    )
    if customgift.save
      render json: customgift
    else
      render json: { errors: customgift.errors.full_messages }, status: 400
    end
  end

  def update
    customgift = Customgift.includes(:customgift_purchaser).find_by(id: params[:id])
    if !customgift
      render json: { errors: "Oops! This customgift has been erased." }, status: 404
    elsif customgift.customgift_purchaser_id != @current_user.id
      render json: {}, status: 401
    else
      customgift.note = params[:note]
      if customgift.save
        render json: customgift
      else
        render json: { errors: customgift.errors.full_messages }, status: 400
      end
    end
  end

  def destroy
    customgift = Customgift.find_by(id: params[:id])
    if !customgift
      render json: { errors: "Oops! This customgift has been erased." }, status: 404
    elsif customgift.customgift_purchaser_id != @current_user.id
      render json: {}, status: 401
    elsif customgift.delete
      render json: { message: "Custom customgift destroyed!" }
    else
      render json: { errors: customgift.errors.full_messages }, status: 400
    end
  end
end
