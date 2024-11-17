class FamiliesController < ApplicationController
  before_action :authenticate_user, only: [:index]
  before_action :authenticate_admin, except: [:index]

  def index
    if !@current_user.family
      render_404
    else
      my_family = Familyd.includes(:users,
                                   :secret_santas,
                                   :gifts,
                                   :purchasers,
                                   :customgifts,
                                   :customgift_purchasers).find_by(id: @current_user.family.id)
      render json: my_family, include: ["users",
                                        "users.secret_santa",
                                        "users.gifts",
                                        "users.gifts.purchaser",
                                        "users.customgifts",
                                        "users.customgifts.customgift_purchaser"]
    end
  end

  def create
    family = Family.new(name: params[:name])
    if family.save
      render json: family
    else
      render json: { errors: family.errors.full_messages }, status: 400
    end
  end

  def update
    family = Family.find_by(id: params[:id])
    if !family
      render_404
    else
      family[:name] = params[:name] || family[:name]
      if family.save
        render json: family
      else
        render json: { errors: family.errors.full_messages }, status: 400
      end
    end
  end

  def destroy
    family = Family.find_by(id: params[:id])
    if !family
      render_404
    else
      family.delete
      render json: { message: "Family destroyed!" }
    end
  end
end

private

def render_404
  render json: { errors: ["No family found"] }, status: 404
end
