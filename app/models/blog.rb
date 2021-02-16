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

  enum category: {
    '未選択': 0,
    'ハイク': 1,
    '自転車': 2,
    'オートバイ': 3
  }
end
