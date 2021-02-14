class RelationshipsController < ApplicationController
  
  def create
    follow = current_user.active_relationships.build(followed_id: params[:user_id])
    follow.save
    redirect_back(fallback_location: user_path(current))
  end

  def destroy
    follow = current_user.active_relationships.find_by(followed_id: params[:user_id])
    follow.destroy
    redirect_back(fallback_location: user_path(current_user))
  end
end
