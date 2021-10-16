class AddRcCourseIdToTeacherSubject < ActiveRecord::Migration[6.0]
  def change
    add_column :teacher_subjects, :rc_course_id, :integer
  end
end
