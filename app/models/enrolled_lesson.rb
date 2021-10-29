class EnrolledLesson < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  monetize :price, as: :price_cents
end
