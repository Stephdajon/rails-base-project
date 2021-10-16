class RcTeacher < ApplicationRecord
  belongs_to :teacher, foreign_key: 'user_id', inverse_of: :rc_teachers
  belongs_to :review_center
  has_many :teacher_subjects, dependent: :destroy
end
