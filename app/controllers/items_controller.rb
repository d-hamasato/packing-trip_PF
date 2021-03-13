class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy, :switch_status]
  before_action :correct_user, only: [:edit, :update, :destroy, :switch_status]
  before_action :redirect_if_private, only: [:show]
  before_action :check_guest, only: [:update, :destroy]

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.new(item_params)
    sent_tags = params[:item][:tag_name].split(",")
    if @item.save
      @item.save_tag(sent_tags)
      flash[:success] = "アイテムが追加されました"
      redirect_to item_path(@item)
    else
      render "new"
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    sent_tags = params[:item][:tag_name].split(",")
    if @item.update(item_params)
      @item.save_tag(sent_tags)
      flash[:success] = "アイテムが更新されました"
      redirect_to item_path(@item)
    else
      render "edit"
    end
  end

  def index
    if params[:user_id]
      @items = User.find(params[:user_id]).items.page(params[:page]).reverse_order.per(20)
    else
      @items = Item.public_items.page(params[:page]).reverse_order.per(20)
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def destroy
    item = Item.find(params[:id])
    if item.destroy
      flash[:success] = "アイテムを削除しました"
      redirect_to user_path(current_user)
    end
  end

  def switch_status
    item = Item.find(params[:id])
    item.update(item_params)
    flash[:success] = "ステータスを変更しました"
    redirect_to item_path(item)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :item_img, :weight, :is_public, :has)
  end

  def correct_user
    item = Item.find(params[:id])
    if current_user.id != item.user_id
      redirect_to root_path
    end
  end

  # 非公開のアイテム詳細ページはアイテムの所有ユーザーのみが参照できる
  def redirect_if_private
    item = Item.find(params[:id])
    if item.is_public? == false
      if user_signed_in? == false
        flash[:info] = "このアイテムは非公開です"
        redirect_back fallback_location: root_path
      elsif item.user_id != current_user.id
        flash[:info] = "このアイテムは非公開です"
        redirect_back fallback_location: root_path
      end
    end
  end

  #ゲストユーザーは過去の投稿（idが一定数より小さい投稿）を削除できない
  def check_guest
    if current_user.email == 'guest@example.com' && params[:id].to_i <= ENV['PROTECT_GUESTS_ITEM_ID_BORDER'].to_i
      flash[:warning] = "ゲストユーザーは過去の投稿を編集・削除できません"
      redirect_back fallback_location: root_path
    end
  end
end
