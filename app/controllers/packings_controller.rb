class PackingsController < ApplicationController
  def new
    @packing = Packing.new
    # @packing.packing_items.build
    @selectable_items = current_user.items.where(has?: true).pluck(:name, :id)
    # 現在ログイン中のユーザーが所持しているアイテムのみ、セレクトボックスに選択肢として表示する
  end

  def index
  end

  def edit
  end

  def show
    @packing = Packing.find(params[:id])
  end

  def create
    if @packing = current_user.packings.create(packing_params)
      flash[:success] = "パッキングが追加されました"
      redirect_to packings_path
    else
      render "new"
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
end
