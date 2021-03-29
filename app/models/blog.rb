require './lib/module/notice'

class Blog < ApplicationRecord
  include Notice

  belongs_to :user
  belongs_to :packing
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :tag_maps,  dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :notifications, dependent: :destroy

  validates :user_id,       presence: true
  validates :title,         presence: true, length: { maximum: 50 }
  validates :departed_date, presence: true
  validates :content,       presence: true
  validates :destination,   length: { maximum: 50 }

  mount_uploader :blog_tmb_img, BlogTmbImgUploader

  # ブログ一覧ページの絞り込み
  scope :search, -> (search_params) do
    return if search_params.blank?
    word_like(search_params[:word])
      .category(search_params[:category])
      .date_from(search_params[:min_date])
      .date_to(search_params[:max_date])
      .tag_has(search_params[:tag_ids])
  end
  scope :word_like, -> (word) { where('title LIKE ? or content LIKE ?', '%'+word+'%', '%'+word+'%') if word.present? }
  scope :category, -> (category) { where(category: category) if category.present? }
  scope :date_from, -> (min_date) { where('? <= departed_date', min_date) if min_date.present? }
  scope :date_to, -> (max_date) { where('departed_date <= ? ', max_date) if max_date.present? }
  # collection_check_boxesの仕様により、tag_idsの配列の先頭に空文字がはいるため、tag_ids[1]でタグの選択があるかを判断
  scope :tag_has, -> (tag_ids) { where(id: TagMap.where(tag_id: tag_ids).pluck(:blog_id).uniq) if tag_ids.present? && tag_ids[1].present? }

  # 引数(number)を上限に、お気に入り数が多い順に直近投稿100件からブログを取得する。（本来は何日前までの投稿としたいがPFのためこの仕様）
  def self.hottest(number)
    self.joins(:favorites).order(id: "DESC").limit(100).group(:blog_id).order(Arel.sql('count(blog_id) desc')).limit(number)
  end

  # 引数のユーザーがお気に入り楼録しているブログを返す。
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

  enum category: {
    '未選択': 0,
    'ハイク': 1,
    '自転車': 2,
    'オートバイ': 3
  }
end
