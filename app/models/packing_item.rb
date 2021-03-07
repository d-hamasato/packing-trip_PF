class PackingItem < ApplicationRecord
  belongs_to :packing

  validates :item_id,    presence: true
  validates :packing_id, presence: true
  validates :qty,        presence: true
end
