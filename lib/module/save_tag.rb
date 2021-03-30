module SaveTag
  # 送信されてきたタブ名から、既に存在するタブ名を除いて新しいタブのみ新規保存する。
  def save_tag(sent_tags)
    sent_tags = sent_tags.split(",")
    # current_tags = 対象オブジェクトに既に紐付いているタグ名
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    new_tags.each do |new|
      new_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_tag
    end
  end
end