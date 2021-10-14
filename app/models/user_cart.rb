class UserCart < ApplicationRecord
  validate :uniqueness_of_lesson_id, on: :create
  belongs_to :lesson
  belongs_to :user

  def uniqueness_of_lesson_id
    existing_record = UserCart.find_by(lesson_id: lesson_id)
    errors.add(:lesson_id, 'Already add to cart this lesson') unless existing_record.nil?
  end
end
