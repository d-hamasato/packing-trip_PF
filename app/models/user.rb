class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name,         presence: true, uniqueness: true
  validates :introduction, length: { maximum: 250 }

  mount_uploader :profile_img, ProfileImgUploader

  has_many :items,     dependent: :destroy
  has_many :packings,  dependent: :destroy
  has_many :blogs,     dependent: :destroy
  has_many :favorites, dependent: :destroy
end
