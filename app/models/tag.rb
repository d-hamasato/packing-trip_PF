class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :items,    through: :tag_maps
  has_many :packings, through: :tag_maps
  has_many :blogs,    through: :tag_maps

  # ブログに関連付いたタグを取得する
  scope :blogs, -> { joins(:blogs).group(:tag_id) }

  def self.hottest(number)
    self.order('count(tag_id) desc').limit(number)
  end

end
