20.times do |n|
  user_id = n + 1

  User.find_or_create_by(id: user_id) do |user|
   user.name = Gimei.first.hiragana
   user.introduction = "自己紹介文です。"
   user.email = "#{user_id}@example.com"
   user.password = "123456"
  end
end