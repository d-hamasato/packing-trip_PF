class BlogsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy, :switch_status]
  before_action :correct_user, only: [:edit, :update, :destroy, :switch_status]
  before_action -> { redirect_if_guest('blog') }, only: [:update, :destroy]
  # before_action :redirect_if_private, only: [:show]

  def new
    @blog = Blog.new
  end

  def index
    #非公開機能の追加は要検討
    if params[:user_id]
      @blogs = User.find(params[:user_id]).blogs.page(params[:page]).reverse_order.per(5)
    else
      @blogs = Blog.page(params[:page]).reverse_order.per(5)
    end
    @tags = Tag.blogs.hottest(20)
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def show
    @blog = Blog.find(params[:id])
    @comment_new = Comment.new
    # ブログに対するパッキングアイテムの紐付けはマストでないため
    if @blog.packing && @blog.packing.is_public?
      @packing = @blog.packing
    end
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    sent_tags = params[:blog][:tag_name]
    if @blog.save
      @blog.save_tag(sent_tags)
      @blog.create_notice_new_blog  #フォロワーにブログの新規投稿を
      flash[:success] = "ブログが投稿されました"
      redirect_to blog_path(@blog)
    else
      render "new"
    end
  end

  def update
    @blog = Blog.find(params[:id])
    sent_tags = params[:blog][:tag_name]
    if @blog.update(blog_params)
      @blog.save_tag(sent_tags)
      flash[:success] = "ブログが更新されました"
      redirect_to blog_path(@blog)
    else
      render "edit"
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    blog.destroy
    flash[:success] = "ブログが削除されました"
    redirect_to blogs_path
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
