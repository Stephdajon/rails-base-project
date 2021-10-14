class UserCart < ApplicationRecord
  validate :uniqueness_of_lesson_id, :on => :create
  belongs_to :lesson
  belongs_to :user

  def uniqueness_of_lesson_id
    existing_record = UserCart.find_by_lesson_id(lesson_id)
    unless existing_record.nil?
      errors.add(:lesson_id, "Already add to cart this lesson")
    end
  end
end
