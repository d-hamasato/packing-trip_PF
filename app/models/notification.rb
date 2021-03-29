class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :sender, class_name: "User", foreign_key: "sender_id", optional: true
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id", optional: true
  belongs_to :blog, optional: true
  belongs_to :comment, optional: true

  enum action: {
    'follow':  0,
    'comment': 1,
    'reply_comment': 2,
    'blog':    3,
    'message': 4
  }
end
