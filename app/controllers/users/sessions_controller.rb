class Users::SessionsController < Devise::SessionsController
  def new_guest
    user = User.guest
    sign_in user
    # ゲストユーザーへの通知を未読に戻す
    notifications = current_user.unchecked_notice
    notifications.update(checked: false) if notifications.any?

    flash[:success] = "ゲストユーザーとしてログインしました"
    redirect_to user_path(user)
  end
end