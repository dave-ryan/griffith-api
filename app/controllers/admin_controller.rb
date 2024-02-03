class AdminController < ApplicationController
  require "./lib/data_wipe_seed.rb"
  before_action :authenticate_admin, except: [:reboot]

  def reboot
    if current_user && current_user.is_admin || User.all.length == 0
      ::Data_Wipe_Seed.reboot
      render json: { message: ["All users and their data have been destroyed and rebuilt"] }
    else
      render json: {}, status: :unauthorized
    end
  end

  def gifts_cleanup
    last_christmas = Date.new(Date.today.year - 1, 12, 25)
    gifts = Gift.joins(:purchaser)
    cleanedup = []
    gifts.each do |gift|
      if gift.created_at < last_christmas && gift.updated_at < last_christmas
        cleanedup.push(gift)
        gift.delete
      end
    end
    render json: { message: "Cleanup Successful", cleanedup: cleanedup }
  end

  def families_index
    families = Family.all.includes(:users,
                                   :gifts,
                                   :purchasers,
                                   :secret_santas,
                                   :customgifts,
                                   :customgift_purchasers)
    render json: families,
           include: [:users => { :include => :secret_santa,
                                 :customgifts => { :include => :purchaser },
                                 :gifts => { :include => :purchaser } }]
  end

  def secret_santa_shuffle
    if @current_user.is_admin
      group1 = User.where(santa_group: 1)
      group2 = User.where(santa_group: 2)
      shuffler(group1)
      shuffler(group2)
      render json: { message: "Secret santas have been assigned!" }
    else
      render json: {}, status: 401
    end
  end

  private

  def shuffler(group)
    assigned_santa = {}
    timer = 500
    while timer > 0
      user1 = group.sample
      user2 = group.sample
      if user1.family_id != user2.family_id && !assigned_santa[user1.name] && !assigned_santa.has_value?(user2.name)
        assigned_santa[user1.name] = user2.name
        user2.secret_santa_id = user1.id
        user2.save
      end
      timer -= 1
      if timer == 0 && assigned_santa.length != group.length
        p "failure! Trying again.."
        timer = 500
        assigned_santa = {}
      elsif assigned_santa.length == group.length
        timer = 0
      end
    end
  end
end
