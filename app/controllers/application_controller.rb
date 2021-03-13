class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
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
end
