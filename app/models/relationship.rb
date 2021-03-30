require './lib/module/create_notice'

class Relationship < ApplicationRecord
  include CreateNotice

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :follower_id, presence: true
end
