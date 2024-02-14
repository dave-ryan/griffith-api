class GiftsController < ApplicationController
  before_action :authenticate_user, only: [:index, :create, :update, :destroy]

  def index
    my_gifts = @current_user.gifts
    render json: my_gifts
  end

  def create
    gift = Gift.new(
      user_id: @current_user.id,
      purchaser_id: nil,
      name: params[:name],
      link: params[:link],
    )
    save_gift(gift)
  end

  def update
    gift = Gift.includes(:purchaser).find_by(id: params[:id])

    if !gift
      render json: { errors: ["Oops! This gift has been erased."] }, status: 404
    elsif params[:gift_action] == "purchasing"
      purchase_gift(gift)
    elsif params[:gift_action] == "unpurchasing"
      unpurchase_gift(gift)
    else
      update_gift(gift, params)
    end
  end

  def destroy
    gift = Gift.find_by(id: params[:id])
    if !gift
      render json: {}, status: 404
    elsif gift.user != @current_user
      render json: {}, status: 401
    else
      gift.delete
      render json: { message: "Gift destroyed!" }
    end
  end

  private

  def update_gift(gift, params)
    if gift.user_id != @current_user.id
      render json: {}, status: 401
    else
      gift[:name] = params[:name] || gift[:name]
      gift[:link] = params[:link] || gift[:link]
      save_gift(gift)
    end
  end

  def unpurchase_gift(gift)
    # if i'm unpurchasing and the gift doesn't have a purchaser, do nothing
    if !gift.purchaser
      render json: gift
      # if i'm unpurchasing but the gift has another purchaser, do nothing
    elsif gift.purchaser && gift.purchaser != @current_user
      render json: gift
    elsif gift.purchaser && gift.purchaser == @current_user
      gift.purchaser = nil
      save_gift(gift)
    end
  end

  def purchase_gift(gift)
    # if i'm trying to purchase and i already did, do nothing
    if gift.purchaser
      if gift.purchaser == @current_user
        render json: gift
      else
        # if i'm purchasing but someone already did, render error
        gift.purchaser && gift.purchaser != @current_user
        render json: { errors: ["Someone already purchased this gift!"], purchaser: gift.purchaser, purchaser_id: gift.purchaser }, status: 400
      end
    else
      gift.purchased_at = DateTime.now
      gift.purchaser = @current_user
      save_gift(gift)
    end
  end

  def save_gift(gift)
    if gift.save
      render json: gift
    else
      render json: { errors: gift.errors.full_messages }, status: 400
    end
  end
end
