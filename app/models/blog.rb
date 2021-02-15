class Blog < ApplicationRecord

  belongs_to :user
  belongs_to :packing
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :tag_maps,  dependent: :destroy
  has_many :tags, through: :tag_maps

  validates :user_id,       presence: true
  validates :title,         presence: true, length: { maximum: 50 }
  validates :departed_date, presence: true
  validates :content,       presence: true
  validates :destination,   presence: true, length: { maximum: 50 }

  mount_uploader :blog_tmb_img, BlogTmbImgUploader

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  enum category: {
    '未選択': 0,
    'ハイク': 1,
    '自転車': 2,
    'オートバイ': 3
  }
end
