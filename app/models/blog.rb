class Blog < ApplicationRecord

  belongs_to :user

  enum category: {
    '未選択': 0,
    'ハイク': 1,
    '自転車': 2,
    'オートバイ': 3
  }
end
