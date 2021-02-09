class Packing < ApplicationRecord

  belongs_to :user
  # gem 'cocoon'でpacking_itemも同時に登録する際、関係性をより明示的にするため inverse_of を記述
  has_many :packing_items, inverse_of: :packing, dependent: :destroy
  accepts_nested_attributes_for :packing_items, reject_if: :all_blank, allow_destroy: true

  mount_uploader :packing_img, ItemImgUploader

  enum number_of_nights: {
    '未選択': 0,
    '日帰り': 1,
    '1泊': 2,
    '2泊〜3泊': 3,
    '4泊〜6泊': 4,
    '7泊〜': 5
  }
end
