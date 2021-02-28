class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :item,    optional: true
  belongs_to :packing, optional: true
  belongs_to :blog,    optional: true
end
