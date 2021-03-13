# ユーザーの初期データ20人分
20.times do |n|
  user_id = n + 1

  User.find_or_create_by(id: user_id) do |user|
   user.name = Gimei.first.hiragana #ダミーテキストジェネレーターでランダムな名前を作成
   user.introduction = "自己紹介文です。"
   user.email = "#{user_id}@example.com"
   user.password = ENV['SEED_USERS_PASSWORD']
  end
end