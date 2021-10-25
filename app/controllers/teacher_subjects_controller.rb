class TeacherSubjectsController < ApplicationController
  before_action :find_rc_teacher
  before_action :authorized?

  def new
    @teacher_subject = @rc_teacher.teacher_subjects.build
    @rc_courses = current_review_center.rc_courses
  end

  def create
    subject_ids = params[:teacher_subject][:subject_id]

    subject_ids.each do |subject_id|
      existing_teacher_subject = @rc_teacher.teacher_subjects.find_by(subject_id: subject_id)
      next if existing_teacher_subject.present?

      subject = Subject.find_by(id: subject_id)
      teacher_subject = @rc_teacher.teacher_subjects.build(teacher_subject_params)
      teacher_subject.subject_id = subject_id
      teacher_subject.rc_course_id = RcCourse.find_by(review_center_id: current_review_center.id, course_id: subject.course.id).id
      teacher_subject.save
    end
    redirect_to teachers_path, notice: 'Successfully assigned subjects.'
  end

  private

  def teacher_subject_params
    params.require(:teacher_subject).permit(:rc_teacher_id, :rc_course_id, subject_id: [])
  end

  def find_rc_teacher
    @rc_teacher = RcTeacher.find_by(id: params[:id])
  end

  def authorized?
    return if current_review_center && @rc_teacher.review_center == current_review_center

    redirect_to authenticated_rc_root_path, alert: 'Unauthorized action'
  end
end
