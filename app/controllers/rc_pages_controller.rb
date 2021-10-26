class RcPagesController < ApplicationController
  before_action :authenticate_review_center!
  before_action :find_rc_course, only: %i[rc_course rc_subject rc_lesson]
  before_action :find_subject, only: %i[rc_subject rc_lesson]
  before_action :find_lessons, only: %i[rc_subject rc_lesson]

  def home
    @rc_courses = current_review_center.rc_courses
    @recently_uploaded_lessons = current_review_center.rc_courses.map { |rc_course| rc_course.lessons.first(5) }.flatten
  end

  def rc_course
    @subjects = @rc_course.course.subjects
  end

  def rc_subject; end

  def rc_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    @related_lessons = @lessons.reject { |lesson| lesson == @lesson }
    @enrolled_lessons = @lesson.enrolled_lessons
  end

  def teachers
    @rc_teachers = current_review_center.rc_teachers
  end

  def teacher_invitations
    @rc_teachers_invitations = current_review_center.rc_teachers.where.not(status: 'approved')
  end

  def approve_teacher; end

  private

  def find_rc_course
    @rc_course = current_review_center.rc_courses.find(params[:rc_course_id])
  end

  def find_subject
    @subject = Subject.find_by(id: params[:subject_id])
  end

  def find_lessons
    @teacher_subjects = @rc_course.teacher_subjects.where(subject_id: @subject.id)
    @lessons = @teacher_subjects.map(&:lessons).flatten
  end
end
