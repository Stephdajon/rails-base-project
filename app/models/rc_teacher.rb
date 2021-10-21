class RcTeacher < ApplicationRecord
  belongs_to :teacher, foreign_key: 'user_id', inverse_of: :rc_teachers
  belongs_to :review_center
  belongs_to :user
  has_many :teacher_subjects, dependent: :destroy

  validate :existing_rc_teacher, on: :create

  private

  def existing_rc_teacher
    rc_teacher = RcTeacher.find_by(user_id: user_id, review_center_id: review_center_id)
    errors.add(:user_id, 'Teacher has an existing invitation from, or already part of, your review center.') unless rc_teacher.nil?
  end
end
