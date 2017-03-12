class Post < ApplicationRecord
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true, length: {minimum: 5}
  validates :user_id, presence: true
  belongs_to :user
end
