class Blog < ApplicationRecord

  belongs_to :user
  belongs_to :packing

  validates :user_id,       presence: true
  validates :title,         presence: true, length: { maximum: 50 }
  validates :departed_date, presence: true
  validates :content,       presence: true
  validates :destination,   presence: true, length: { maximum: 50 }

  mount_uploader :blog_tmb_img, BlogTmbImgUploader

  enum category: {
    '未選択': 0,
    'ハイク': 1,
    '自転車': 2,
    'オートバイ': 3
  }
end
