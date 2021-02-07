class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 500 }
  validates :weight, numericality: { only_integer: true }
end
