class UsersController < ApplicationController
  before_action :check_guest, only: :edit

  def index
    if params[:following_id]#ヘッダーのフォロー中ユーザーからの遷移
      @users = User.find(params[:following_id]).following.reverse_order.page(params[:page]).per(9)
    elsif params[:followed_id]#フォローボタン下、""人がフォロー中からの遷移
      @users = User.find(params[:followed_id]).followers.reverse_order.page(params[:page]).per(9)
    else
      @users = User.page(params[:page]).reverse_order.per(9)
    end
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

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_img)
  end

  def check_guest
    if current_user.email == 'guest@example.com'
      flash[:warning] = "ゲストユーザーは編集できません"
      redirect_back fallback_location: root_path
    end
  end
end