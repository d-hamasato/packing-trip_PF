class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_items
    search_params = item_search_params
    if search_params[:only_myitem]
      @items = current_user.items.search(search_params)
    else
      @items = Item.public_items.search(search_params)
    end
  end

  def search_packings
    search_params = packing_search_params
    if search_params[:only_mypacking]
      @packings = current_user.packings.search(search_params)
    else
      @packings = Packing.public_packings.search(search_params)
    end
  end

  def search_blogs
    search_params = blog_search_params
    if search_params[:only_myblog]
      @blogs = current_user.blogs.search(search_params).page(params[:page]).reverse_order.per(10)
    else
      @blogs = Blog.search(search_params).page(params[:page]).reverse_order.per(10)
    end
  end

  def search_users
    search_params = user_search_params
    if search_params[:order_followers]
      @users = User.order_followers.search(search_params).page(params[:page]).per(20)
    else
      @users = User.search(search_params).page(params[:page]).reverse_order.per(20)
    end
  end

  def search_all_contents
    search_params = all_contents_search_params
    if search_params[:only_myfavorites]
      @blogs = Blog.favorites(current_user).search(search_params).page(params[:page]).reverse_order.per(10)
      @packings = Packing.favorites(current_user).search(search_params)
      @items = Item.favorites(current_user).search(search_params)
    else
      @blogs = Blog.search(search_params).page(params[:page]).reverse_order.per(10)
      @packings = Packing.public_packings.search(search_params)
      @items = Item.public_items.search(search_params)
    end
  end

  private

  def item_search_params
    params.fetch(:search, {}).permit(:word, :min_weight, :max_weight, :only_myitem, tag_ids: [])
  end

  def packing_search_params
    params.fetch(:search, {}).permit(:word, :selected_number_of_nights, :only_mypacking, tag_ids: [])
  end

  def blog_search_params
    params.fetch(:search, {}).permit(:word, :category, :min_date, :max_date, :only_myblog, tag_ids: [])
  end

  def user_search_params
    params.fetch(:search, {}).permit(:word, :order_followers)
  end

  def all_contents_search_params
    params.fetch(:search, {}).permit(:word, :only_myfavorites, tag_ids: [])
  end

end
