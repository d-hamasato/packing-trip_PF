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

  # アイテム一覧ページの絞り込み
  scope :search, -> (search_params) do
    return if search_params.blank?
    word_like(search_params[:word])
      .tag_has(search_params[:tag_ids])
      .weight_from(search_params[:min_weight])
      .weight_to(search_params[:max_weight])
  end
  scope :word_like, -> (word) { where('name LIKE ? or description LIKE ?', '%'+word+'%', '%'+word+'%') if word.present? }
  scope :weight_from, -> (min_weight) { where('? <= weight', min_weight) if min_weight.present? }
  scope :weight_to, -> (max_weight) { where('weight <= ? ', max_weight) if max_weight.present? }
  # collection_check_boxesの仕様により、tag_idsの配列の先頭に空文字がはいるため、tag_ids[1]でタグの選択があるかを判断
  scope :tag_has, -> (tag_ids) { where(id: TagMap.where(tag_id: tag_ids).pluck(:item_id).uniq) if tag_ids[1].present?}

  # パッキングに紐付いた複数のアイテムを取得する。(packing.itemsで取得できるようにアソシエーションを改善する)
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
end
