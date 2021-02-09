class PackingsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy, :switch_status]
  before_action :correct_user, only: [:edit, :create, :update, :destroy, :switch_status]
  before_action :is_public?, only: [:show]

  def new
    @packing = Packing.new
    @selectable_items = current_user.items.where(has?: true).pluck(:name, :id)
    # 現在ログイン中のユーザーが所持しているアイテムのみ、セレクトボックスに選択肢として表示する
  end

  def index
    @packings = Packing.where(is_public?: true)
  end

  def edit
    @packing = Packing.find(params[:id])
    @selectable_items = current_user.items.where(has?: true).pluck(:name, :id)
    # 現在ログイン中のユーザーが所持しているアイテムのみ、セレクトボックスに選択肢として表示する
  end

  def show
    @packing = Packing.find(params[:id])
    # packing_weightメソッドは本コントローラーの下部に記載
    @packing_weight = packing_weight(@packing)
    # @packingに紐付いたアイテムを取得
    @items = Item.where(is_public?: true, id: @packing.packing_items.pluck(:item_id))
  end

  def create
    if @packing = current_user.packings.create(packing_params)
      flash[:success] = "パッキングが追加されました"
      redirect_to packings_path
    else
      render "new"
    end
  end

  def update
    @packing = Packing.find(params[:id])
    if @packing.update(packing_params)
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

  def switch_status
    packing = Packing.find(params[:id])
    if packing.update(packing_params)
      flash[:success] = "ステータスを変更しました"
      redirect_to packing_path(packing)
    else
      flash[:success] = "ステータス変更に失敗しました"
      redirect_to packing_path(packing)
    end
  end

  private

  def packing_params
    params.require(:packing).permit(
      :name,
      :description,
      :number_of_nights,
      :packing_img,
      :is_public?,
      packing_items_attributes:[
        :id,
        :item_id,
        :qty,
        :_destroy
      ]
    )
  end

  def packing_weight(packing)
    packing_items = packing.packing_items
    arry = []
    packing_items.each do |packing_item|
      arry << Item.find(packing_item.item_id).weight
    end
    arry.sum
  end

  def correct_user
    packing = Packing.find(params[:id])
    if current_user.id != packing.user_id
      redirect_to root_path
    end
  end

  # 非公開のパッキング詳細ページはアイテムの所有ユーザーのみが参照できる
  def is_public?
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
