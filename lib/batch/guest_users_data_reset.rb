class Batch::GuestUsersDataReset
  def self.guest_users_data_reset
    user = User.find_by(email: "guest@example.com")
    user.items.where('id > ?', ENV['PROTECT_GUESTS_ITEM_ID_BORDER'].to_i).delete_all
    user.packings.where('id > ?', ENV['PROTECT_GUESTS_PACKING_ID_BORDER'].to_i).delete_all
    user.blogs.where('id > ?', ENV['PROTECT_GUESTS_BLOG_ID_BORDER'].to_i).delete_all
    p"ゲストユーザーの新規投稿を全て削除しました"
  end
end
