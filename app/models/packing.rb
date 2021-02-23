class Packing < ApplicationRecord

  belongs_to :user
  has_many :blogs
  has_many :favorites, dependent: :destroy
  has_many :tag_maps,  dependent: :destroy
  has_many :tags, through: :tag_maps
  # gem 'cocoon'でpacking_itemも同時に登録する際、関係性をより明示的にするため inverse_of を記述
  has_many :packing_items, inverse_of: :packing, dependent: :destroy
  accepts_nested_attributes_for :packing_items, reject_if: :all_blank, allow_destroy: true

  mount_uploader :packing_img, PackingImgUploader

  scope :public_packings, -> { where(is_public: true) }

  # パッキング一覧ページの絞り込み
  scope :search, -> (search_params) do
    return if search_params.blank?
    word_like(search_params[:word])
      .tag_has(search_params[:tag_ids])
      .number_of_nights_has(search_params[:selected_number_of_nights])
  end
  scope :word_like, -> (word) { where('name LIKE ? or description LIKE ?', '%'+word+'%', '%'+word+'%') if word.present? }
  scope :number_of_nights_has, -> (selected_number_of_nights) { where(number_of_nights: selected_number_of_nights) if selected_number_of_nights.present? }
  # collection_check_boxesの仕様により、tag_idsの配列の先頭に空文字がはいるため、tag_ids[1]でタグの選択があるかを判断
  scope :tag_has, -> (tag_ids) { where(id: TagMap.where(tag_id: tag_ids).pluck(:packing_id).uniq) if tag_ids.present? && tag_ids[1].present? }

  # 引数のユーザーがお気に入り楼録しているパッキングを返す。
  def self.favorites(user)
    self.joins(:favorites).where(favorites: { user_id: user})
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

  enum number_of_nights: {
    '未選択': 0,
    '日帰り': 1,
    '1泊': 2,
    '2泊〜3泊': 3,
    '4泊〜6泊': 4,
    '7泊〜': 5
  }
end
