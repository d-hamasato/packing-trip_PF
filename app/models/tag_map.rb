class TagMap < ApplicationRecord
  belongs_to :tag
  belongs_to :item,    optional: true
  belongs_to :packing, optional: true
  belongs_to :blog,    optional: true
end
