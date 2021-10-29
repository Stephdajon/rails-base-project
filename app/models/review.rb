class Review < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  validates :rating, :comment, presence: true
end
