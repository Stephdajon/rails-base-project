class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:lesson_details]
  before_action :required_students, only: %i[my_lessons lesson_details paid_lesson_access]
  before_action :required_payment, only: [:paid_lesson_access]

  def lesson_details
    @lesson_details = Course.find(params[:course_id])
    @lesson = Lesson.find(params[:lesson_id])
    @lessons = Lesson.where(teacher_subject_id: @lesson.teacher_subject.subject_id)
  end

  def paid_lesson_access
    @lesson = Lesson.find(params[:lesson_id])
  end

  def my_lessons
    @lessons = EnrolledLesson.where(user_id: current_user.id)
  end

  private

  def required_payment
    enrolled_lesson = EnrolledLesson.find_by(user_id: current_user.id, lesson_id: params[:lesson_id])
    lesson = Lesson.find(params[:lesson_id])
    return if enrolled_lesson

    redirect_to lesson_details_path(lesson.teacher_subject.subject.name.split.join, lesson.teacher_subject.subject.course_id, lesson.id), alert: 'Buy first to access the lesson'
  end

  def required_students
    authenticate_user!
    redirect_to root_path, alert: 'You are not authorized to perform this action' unless current_user.type == 'Student'
  end
end
