class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :items,    through: :tag_maps
  has_many :packings, through: :tag_maps
  has_many :blogs,    through: :tag_maps
end
