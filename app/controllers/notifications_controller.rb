class NotificationsController < ApplicationController

  def checked_notice
    notification = @notifications.find(params[:id])
    notification.update(checked: true)
    @notifications = current_user.passive_notifications.where(checked: false).limit(5)
  end

  def checked_notice_all
    notifications = current_user.passive_notifications.where(checked: false)
    notifications.each do |notification|
      notification.update(checked: true)
    end
  end

  def redirect_check_content
    notification = @notifications.find(params[:id])
    notification.update(checked: true)

    case notification.action
    when "follow"
      redirect_to user_path(notification.sender)
    when "comment", "reply_comment"
      redirect_to blog_path(notification.comment.blog)
    when "blog"
      redirect_to blog_path(notification.blog)
    end
  end
end
