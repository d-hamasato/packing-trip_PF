class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :items,    through: :tag_maps
  has_many :packings, through: :tag_maps
  has_many :blogs,    through: :tag_maps

  # アイテムに紐付いているタグのidを取得
  def self.item_tags
    item_tag_ids =TagMap.where("item_id IS NOT NULL").pluck(:tag_id).uniq
    self.where(id: item_tag_ids)
  end

end
