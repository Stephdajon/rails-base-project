class CoursesController < ApplicationController
  def lesson_details
    @lesson_details = Course.find(params[:course_id]) 
    @lesson = Lesson.find(params[:lesson_id])
    @lessons = Lesson.where(teacher_subject_id: @lesson.teacher_subject.subject_id)
  end
end
