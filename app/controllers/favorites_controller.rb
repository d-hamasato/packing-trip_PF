class FavoritesController < ApplicationController
  def create
    if params[:item_id]
      item = Item.find(params[:item_id])
      favorite = current_user.favorites.new(item_id: item.id)
    elsif params[:packing_id]
      packing = Packing.find(params[:packing_id])
      favorite = current_user.favorites.new(packing_id: packing.id)
    elsif params[:blog_id]
      blog = Blog.find(params[:blog_id])
      favorite = current_user.favorites.new(blog_id: blog.id)
    end
    favorite.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if params[:item_id]
      item = Item.find(params[:item_id])
      favorite = current_user.favorites.find_by(item_id: item.id)
    elsif params[:packing_id]
      packing = Packing.find(params[:packing_id])
      favorite = current_user.favorites.find_by(packing_id: packing.id)
    elsif params[:blog_id]
      blog = Blog.find(params[:blog_id])
      favorite = current_user.favorites.find_by(blog_id: blog.id)
    end
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
