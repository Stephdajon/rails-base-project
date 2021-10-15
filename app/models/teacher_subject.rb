class TeacherSubject < ApplicationRecord
  belongs_to :rc_teacher
  belongs_to :subject
  belongs_to :rc_course
  has_many :lessons, dependent: :destroy
end
