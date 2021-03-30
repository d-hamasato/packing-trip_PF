module CreateNotice
  # ブロブページでのコメント投稿時に通知作成
  def create_notice_comment
    if self.parent_id.blank?
      Notification.create(
        sender_id: self.user_id,
        recipient_id: self.blog.user.id,
        comment_id: self.id,
        action: "comment"
      ) unless self.user == self.blog.user
    else #コメントへの返信
      Notification.create(
        sender_id: self.user_id,
        recipient_id: self.parent.user.id,
        comment_id: self.id,
        action: "reply_comment"
      ) unless self.user == self.parent.user
    end
  end

  # ブログ投稿時にフォロワーに通知作成
  def create_notice_new_blog
    followers = self.user.followers
    followers.each do |follower|
      Notification.create(
        sender_id: self.user_id,
        recipient_id: follower.id,
        blog_id: self.id,
        action: "blog"
      )
    end
  end

  # ユーザーフォロー時に通知作成。過去のフォローで既に通知作成済みの場合は通知を行わない。
  def create_notice_follow
    Notification.find_or_create_by(
      sender_id: self.follower_id,
      recipient_id: self.followed_id,
      action: "follow"
    )
  end

  # def create_notice_massage
  # end
end