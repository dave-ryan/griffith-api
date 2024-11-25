class FriendshipsController < ApplicationController
    before_action :authenticate_user

    def index
        friends = current_user.friends
        render json: friends, status: 200
    end

    def create
        friendship1 = Friendship.create(user_id: current_user.id, friend_id: params[:id])
        friendship2 = Friendship.create(user_id: params[:id], friend_id: current_user.id)
        if friendship1.save! && friendship2.save!
            render json: {message: "Friendship created!", friendships: [friendship1, friendship2]}, status: 200
        end
    end
end
