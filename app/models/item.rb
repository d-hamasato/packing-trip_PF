class Item < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :tag_maps,  dependent: :destroy
  has_many :tags, through: :tag_maps

  validates :name,        presence: true
  validates :description, length: { maximum: 500 }
  validates :weight,      numericality: { only_integer: true }

  mount_uploader :item_img, ItemImgUploader

  scope :public_items, -> { where(is_public: true) }

  # パッキングに紐付いた複数のアイテムを取得する。
  def self.packing_items(packing)
    self.where(id: packing.packing_items.pluck(:item_id))
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 送信されてきたタブ名から、既に存在するタブ名を除いて新しいタブのみ新規保存する。
  def save_tag(sent_tags)
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

  def self.search_for(search_word, tag_ids)
    tag_items_id = TagMap.where(tag_id: tag_ids).pluck(:item_id).uniq
    if search_word.present? && tag_ids.present?
      self.where(id: tag_items_id).where('name LIKE ? or description LIKE ?', '%'+search_word+'%', '%'+search_word+'%')
    elsif search_word.present?
      self.where('name LIKE ? or description LIKE ?', '%'+search_word+'%', '%'+search_word+'%')
    else
      self.where(id: tag_items_id)
    end
  end

end
