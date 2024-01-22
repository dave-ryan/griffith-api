class CustomgiftsController < ApplicationController
  before_action :authenticate_user

  def create
    gift = Customgift.new(
      user_id: params[:user_id],
      customgift_purchaser_id: params[:customgift_purchaser_id],
      note: params[:note],
    )
    if gift.save
      render json: gift
    else
      render json: { errors: gift.errors.full_messages }
    end
  end

  def update
    gift = Customgift.includes(:customgift_purchaser).find_by(id: params[:id])
    if gift
      gift.note = params[:note]
    end
    if gift.save
      render json: gift
    else
      render json: { errors: gift.errors.full_messages }
    end
  end

  def destroy
    gift = Customgift.find_by(id: params[:id])
    gift.delete
    render json: { message: "Custom gift destroyed!" }
  end
end
