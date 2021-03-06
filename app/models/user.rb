class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items,     dependent: :destroy
  has_many :packings,  dependent: :destroy
  has_many :blogs,     dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments,  dependent: :destroy
  # フォロー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # 通知機能
  has_many :active_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "recipient_id", dependent: :destroy

  validates :name,         presence: true, uniqueness: true
  validates :introduction, length: { maximum: 250 }

  mount_uploader :profile_img, ProfileImgUploader

  scope :order_followers, -> { joins(:followers).group(:followed_id).order(Arel.sql('count(followed_id) desc')) }

  # ユーザー一覧ページの絞り込み
  scope :search, -> (search_params) do
    return if search_params.blank?
    word_like(search_params[:word])
  end
  scope :word_like, -> (word) { where('users.name LIKE ? or users.introduction LIKE ?', '%'+word+'%', '%'+word+'%') if word.present? }

  # ゲストログインボタンが押された際のメソッド(Users::SessionsController)
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def following?(user)
    following.include?(user)
  end

  # 未読の通知を取得
  def unchecked_notice
    self.passive_notifications.where(checked: false)
  end
end
