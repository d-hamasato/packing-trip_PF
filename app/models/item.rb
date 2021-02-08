class Item < ApplicationRecord

  belongs_to :user

  validates :name, presence: true
  validates :description, length: { maximum: 500 }
  validates :weight, numericality: { only_integer: true }

  mount_uploader :item_img, ItemImgUploader
end
