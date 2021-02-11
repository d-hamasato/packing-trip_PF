class BlogsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy, :switch_status]
  before_action :correct_user, only: [:edit, :update, :destroy, :switch_status]
  # before_action :redirect_if_private, only: [:show]

  def new
    @blog = Blog.new
    @selectable_packings = current_user.packings.pluck(:name, :id)
    @h2_text = "新規ブログ投稿"
    @submit_text = "ブログ投稿"
  end

  def index
    #非公開機能の追加は要検討
    @blogs = Blog.all
  end

  def edit
    @blog = Blog.find(params[:id])
    @selectable_packings = current_user.packings.pluck(:name, :id)
    @h2_text = "ブログ編集"
    @submit_text = "ブログ編集"
  end

  def show
    @blog = Blog.find(params[:id])
    # ブログに対するパッキングアイテムの紐付けはマストでないため、紐付いた公開中のパッキングが存在するときのみインスタンス変数を用意
    if @blog.packing && @blog.packing.is_public?
      @packing = @blog.packing
      @items = Item.public_items.packing_items(@packing)
    end
    # if @blog.blog_tmb_img #使うか検討中
    #   @blog_top_image = @blog.blog_tmb_img.url
    # end
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
      flash[:success] = "ブログが投稿されました"
      redirect_to blog_path(@blog)
    else
      render "new"
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params)
      flash[:success] = "ブログが更新されました"
      redirect_to blog_path(@blog)
    else
      render "edit"
    end
  end

  private

  def blog_params
    params.require(:blog).permit(
      :packing_id,
      :title,
      :category,
      :departed_date,
      :destination,
      :blog_tmb_img,
      :content
    )
  end

  # editアクションなどはブログの投稿者のみが使用可能とするため
  def correct_user
    blog = Blog.find(params[:id])
    if current_user.id != blog.user_id
      redirect_to root_path
    end
  end

  # 非公開のブログ詳細ページはアイテムの所有ユーザーのみが参照できる
  # def redirect_if_private
  #   blog = Blog.find(params[:id])
  #   if blog.is_public? == false
  #     if user_signed_in? == false
  #       flash[:info] = "このブログは非公開です"
  #       redirect_back fallback_location: root_path
  #     elsif blog.user_id != current_user.id
  #       flash[:info] = "このブログは非公開です"
  #       redirect_back fallback_location: root_path
  #     end
  #   end
  # end
end
