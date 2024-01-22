class FamiliesController < ApplicationController
  before_action :authenticate_user, only: [:index]
  before_action :authenticate_admin, except: [:index]

  def index
    my_family = Family.includes(:users,
                                :gifts,
                                :purchasers,
                                :secret_santas,
                                :customgifts,
                                :customgift_purchasers).find_by(id: @current_user.family.id)
    render json: my_family,
           include: [:users => { include: :secret_santa,
                                 :customgifts => { include: :purchaser },
                                 :gifts => { include: :purchaser } }]
  end

  def create
    family = Family.new(name: params[:name])
    if family.save
      render json: { message: "Family successfully created!, #{family.name}" }
    else
      render json: { message: "Family failed to create!" }
    end
  end

  def update
    family = Family.find_by(id: params[:id])
    family[:name] = params[:name] || family[:name]
    if family.save
      render json: family
    else
      render json: { errors: family.errors.full_messages }
    end
  end

  def destroy
    family = Family.find_by(id: params[:id])
    family.delete
    render json: { message: "Gift destroyed!" }
  end
end
