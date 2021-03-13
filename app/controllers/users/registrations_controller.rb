class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: [:destroy, :update]

  def check_guest
    if current_user.email == 'guest@example.com'
      flash[:warning] = "ゲストユーザーの編集・削除はできません"
      redirect_back fallback_location: root_path
    end
  end

end