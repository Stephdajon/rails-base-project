class RcTeacher < ApplicationRecord
  belongs_to :teacher, foreign_key: 'user_id', inverse_of: :rc_teachers
  belongs_to :review_center
  belongs_to :user
  has_many :teacher_subjects, dependent: :destroy

  validate :existing_rc_teacher, on: :create

  private

  def existing_rc_teacher
    rc_teacher = RcTeacher.find_by(user_id: user_id, review_center_id: review_center_id)
    return if rc_teacher.nil?

    errors.add(:user_id, 'is already part of your review center.') if rc_teacher.status == 'approved'
    errors.add(:user_id, 'has an existing invitation or request from your review center.') if rc_teacher.status == 'pending'
    errors.add(:user_id, 'invitation or request that has been sent previously has been rejected.') if rc_teacher.status == 'rejected'
  end
end
