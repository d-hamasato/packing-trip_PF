class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_notifications, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  # ゲストユーザーは過去の投稿を削除できないようにリダイレクトさせる
  def redirect_if_guest(obj)
    case obj
    when 'item'
      id_border = ENV['PROTECT_GUESTS_ITEM_ID_BORDER'].to_i
    when 'packing'
      id_border = ENV['PROTECT_GUESTS_PACKING_ID_BORDER'].to_i
    when 'blog'
      id_border = ENV['PROTECT_GUESTS_BLOG_ID_BORDER'].to_i
    end

    if current_user.email == 'guest@example.com' && params[:id].to_i <= id_border
      flash[:warning] = "ゲストユーザーは過去の投稿を編集・削除できません"
      redirect_back fallback_location: root_path
    end
  end

  # ヘッダーに表示させる通知を取得する
  def check_notifications
    @notifications = current_user.unchecked_notice.limit(5)
  end
end
