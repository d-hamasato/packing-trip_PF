class Item < ApplicationRecord

  belongs_to :user
  has_many :favorites

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
end
