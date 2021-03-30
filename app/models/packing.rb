require './lib/module/save_tag'

class Packing < ApplicationRecord
  include SaveTag

  belongs_to :user
  has_many :blogs
  has_many :favorites, dependent: :destroy
  has_many :tag_maps,  dependent: :destroy
  has_many :tags, through: :tag_maps
  # gem 'cocoon'でpacking_itemも同時に登録する際、関係性をより明示的にするため inverse_of を記述
  has_many :packing_items, inverse_of: :packing, dependent: :destroy
  accepts_nested_attributes_for :packing_items, reject_if: :all_blank, allow_destroy: true

  validates :name,             presence: true
  validates :description,      length: { maximum: 500 }
  validates :number_of_nights, presence: true

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

  enum number_of_nights: {
    '未選択': 0,
    '日帰り': 1,
    '1泊': 2,
    '2泊〜3泊': 3,
    '4泊〜6泊': 4,
    '7泊〜': 5
  }
end
