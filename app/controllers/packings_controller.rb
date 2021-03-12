class PackingsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy, :switch_status]
  before_action :correct_user, only: [:edit, :update, :destroy, :switch_status]
  before_action :redirect_if_private, only: [:show]

  def new
    @packing = Packing.new
  end

  def index
    if params[:user_id]
      @packings = User.find(params[:user_id]).packings.page(params[:page]).reverse_order.per(8)
    else
      @packings = Packing.public_packings.page(params[:page]).reverse_order.per(8)
    end
  end

  def edit
    @packing = Packing.find(params[:id])
  end

  def show
    @packing = Packing.find(params[:id])
    # @packingの総重量を紐付いたアイテムの重量から合計
    @packing_weight = Item.packing_items(@packing).sum(:weight)
    # @packingに紐付いた公開中ステータスのアイテムを取得
    @items = Item.public_items.packing_items(@packing)
  end

  def create
    @packing = current_user.packings.new(packing_params)
    sent_tags = params[:packing][:tag_name].split(",")
    if @packing.save
      @packing.save_tag(sent_tags)
      flash[:success] = "パッキングが追加されました"
      redirect_to packing_path(@packing)
    else
      render "new"
    end
  end

  def update
    @packing = Packing.find(params[:id])
    sent_tags = params[:packing][:tag_name].split(",")
    if @packing.update(packing_params)
      @packing.save_tag(sent_tags)
      flash[:success] = "パッキングが更新されました"
      redirect_to packing_path(@packing)
    else
      render "edit"
    end
  end

  def destroy
    packing = Packing.find(params[:id])
    if packing.destroy
      flash[:success] = "パッキングを削除しました"
      redirect_to user_path(current_user)
    end
  end
  # 公開非公開のステータス変更
  def switch_status
    packing = Packing.find(params[:id])
    packing.update(packing_params)
    flash[:success] = "ステータスを変更しました"
    redirect_to packing_path(packing)
  end

  private

  def packing_params
    params.require(:packing).permit(
      :name,
      :description,
      :number_of_nights,
      :packing_img,
      :is_public,
      packing_items_attributes:[
        :id,
        :item_id,
        :qty,
        :_destroy
      ]
    )
  end

  # editアクションなどはパッキングの所有者のみが使用可能とするため
  def correct_user
    packing = Packing.find(params[:id])
    if current_user.id != packing.user_id
      redirect_to root_path
    end
  end

  # 非公開のパッキング詳細ページはアイテムの所有ユーザーのみが参照できる
  def redirect_if_private
    packing = Packing.find(params[:id])
    if packing.is_public? == false
      if user_signed_in? == false
        flash[:info] = "このパッキングは非公開です"
        redirect_back fallback_location: root_path
      elsif packing.user_id != current_user.id
        flash[:info] = "このパッキングは非公開です"
        redirect_back fallback_location: root_path
      end
    end
  end
end
