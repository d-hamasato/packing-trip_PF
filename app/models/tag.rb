class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :items,    through: :tag_maps
  has_many :packings, through: :tag_maps
  has_many :blogs,    through: :tag_maps

  # タグ付けのされている数が多い順に、上限20のタグを取得する
  scope :hottest, -> { order('count(tag_id) desc').limit(20) }
  # ブログに関連付いたタグを取得する
  scope :blogs, -> { joins(:blogs).group(:tag_id) }

end
