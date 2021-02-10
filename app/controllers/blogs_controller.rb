class BlogsController < ApplicationController
  def new
    @blog = Blog.new
    @selectable_packings = current_user.packings.pluck(:name, :id)
    @h2_text = "新規ブログ投稿"
    @submit_text = "ブログ投稿"
  end

  def index
  end

  def edit
    @blog = Blog.find(params[:id])
    @selectable_packings = current_user.packings.pluck(:name, :id)
    @h2_text = "ブログ編集"
    @submit_text = "ブログ編集"
  end

  def show
    @blog = Blog.find(params[:id])
    if @blog.packing
      @packing = @blog.packing
      @items = Item.public_items.packing_items(@packing)
    end
    if @blog.blog_tmb_img
      @blog_top_image = @blog.blog_tmb_img.url
    end
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
end
