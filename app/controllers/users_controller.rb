class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    # current_user以外がアクセスした場合は非公開アイテム、パッキングを表示しない。
    if user_signed_in? && @user.id == current_user.id
      @items = @user.items
      @packings = @user.packings
      # @packing = Packing.find(2)#カード作成のため
      # @packing_weight = Item.packing_items(@packing).sum(:weight)
    else
      @items = @user.items.public_items
      @packings = @user.packings.public_packings
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "ユーザー登録情報が更新されました"
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end
end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_img)
  end