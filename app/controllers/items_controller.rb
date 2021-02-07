class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = current_user.item.new(item_params)
    if @item.save
      redirect_to item_path(@item)#サクセスメッセージ
    else
      render "new"
    end
  end

  def index
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :item_img, :weight)
  end
end

