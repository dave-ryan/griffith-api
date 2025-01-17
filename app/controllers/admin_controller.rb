class AdminController < ApplicationController
  require "./lib/data_wipe_seed.rb"
  before_action :authenticate_admin, except: [:reboot]

  def reboot
    if current_user && current_user.is_admin || User.all.length == 0
      ::Data_Wipe_Seed.reboot
      render json: { message: "All users and their data have been destroyed and rebuilt" }
    else
      render json: {}, status: 401
    end
  end

  def gifts_cleanup
    this_christmas = Date.new(Date.today.year, 12, 25)
    last_christmas = Date.new(Date.today.year - 1, 12, 25)
    if Date.today > this_christmas
      last_christmas = this_christmas
    end

    gifts = Gift.where.not(purchaser: nil)
    customgifts = Customgift.all
    cleaned_up = []

    gifts.each do |gift|
      # gift was purchased before last christmas or purchased before BD & BD has passed
      if gift.user.birthday
        users_birthdate = Date.new(Date.today.year, gift.user.birthday.month, gift.user.birthday.day)
      end
      if gift.purchased_at < last_christmas || gift.purchased_at = nil || (users_birthdate != nil && gift.purchased_at < users_birthdate && user_birthday < Date.today)
        cleaned_up.push(gift)
        gift.delete
      end
    end
    customgifts.each do |gift|
      # gift was purchased before last christmas or purchased before BD & BD has passed
      if gift.user.birthday
        users_birthdate = Date.new(Date.today.year, gift.user.birthday.month, gift.user.birthday.day)
      end
      if gift.purchased_at < last_christmas || gift.purchased_at = nil || (users_birthdate != nil && gift.purchased_at < users_birthdate && user_birthday < Date.today)
        cleaned_up.push(gift)
        gift.delete
      end
    end

    render json: { message: "Clean up Successful", cleaned_up: cleaned_up }, status: 200
  end

  def families_index
    families = Family.all
    render json: families, each_serializer: FamilyMinSerializer
  end

  def secret_santa_shuffle
    if @current_user.is_admin
      men = User.where(santa_group: 1)
      women = User.where(santa_group: 2)
      if is_imbalanced(men) || is_imbalanced(women)
        render json: { errors: ["Secret Santa Shuffling is not possible because one family has too many members"] }, status: 406
      else
        shuffler(men)
        shuffler(women)
        render json: { message: "Secret santas have been assigned!" }
      end
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
      if user1.family_id != user2.family_id && !assigned_santa[user1.id] && !assigned_santa.has_value?(user2.id)
        assigned_santa[user1.id] = user2.id
        user2.secret_santa_id = user1.id
        user2.save
      end
      timer -= 1
      if timer == 0 && assigned_santa.length != group.length
        timer = 500
        assigned_santa = {}
      elsif assigned_santa.length == group.length
        timer = 0
      end
    end
  end

  def is_imbalanced(group)
    family_sizes = group.group_by(&:family_id).transform_values(&:count)
    largest_family_size = family_sizes.values.max
    largest_family_id = family_sizes.key(family_sizes.values.max)
    users_not_in_largest_family = group.reject { |user| user.family_id == largest_family_id }

    return largest_family_size > users_not_in_largest_family.size
  end
end
