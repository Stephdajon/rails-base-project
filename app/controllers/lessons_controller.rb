class LessonsController < ApplicationController
  before_action :find_review_center
  before_action :find_rc_teacher
  before_action :authorized?
  before_action :find_teacher_subjects, only: %i[index new create]
  before_action :find_rc_course, only: [:create]

  def index
    @lessons = @teacher_subjects.collect(&:lessons).flatten
  end

  def show
    @lesson = Lesson.find_by(id: params[:id])
    @teacher_subject = @lesson.teacher_subject
    @related_lessons = @teacher_subject.lessons.where.not(id: @lesson.id)
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.rc_course_id = @rc_course.id

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to rc_teacher_lessons_path(@review_center), notice: 'Successfully uploaded a lesson' }
      else
        @lesson.video.purge
        @lesson.thumbnail.purge
        format.js { render 'errors' }
      end
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:name, :details, :price, :teacher_subject_id, :rc_course_id, :video, :thumbnail, :status, :tag_list)
  end

  def find_review_center
    @review_center = ReviewCenter.find_by(id: params[:review_center_id])
  end

  def find_rc_teacher
    return unless current_user && current_user.type == 'Teacher'

    @rc_teacher = current_user.rc_teachers.find_by(review_center_id: @review_center.id)
  end

  def authorized?
    return if (@rc_teacher && @rc_teacher.status == 'approved') || current_review_center

    flash[:alert] = 'Not allowed to access restricted page.'
    redirect_to root_path and return
  end

  def find_teacher_subjects
    @teacher_subjects = @rc_teacher.teacher_subjects
  end

  def find_rc_course
    teacher_subject = @teacher_subjects.find_by(id: params[:lesson][:teacher_subject_id])

    @rc_course = teacher_subject.rc_course
  end
end
