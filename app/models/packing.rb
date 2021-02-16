class Packing < ApplicationRecord

  belongs_to :user
  has_many :blogs
  has_many :favorites, dependent: :destroy
  has_many :tag_maps,  dependent: :destroy
  has_many :tags, through: :tag_maps
  # gem 'cocoon'でpacking_itemも同時に登録する際、関係性をより明示的にするため inverse_of を記述
  has_many :packing_items, inverse_of: :packing, dependent: :destroy
  accepts_nested_attributes_for :packing_items, reject_if: :all_blank, allow_destroy: true

  mount_uploader :packing_img, ItemImgUploader

  scope :public_packings, -> { where(is_public: true) }

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

  enum number_of_nights: {
    '未選択': 0,
    '日帰り': 1,
    '1泊': 2,
    '2泊〜3泊': 3,
    '4泊〜6泊': 4,
    '7泊〜': 5
  }
end
