class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :required_admin

  def index; end

  def user_list
    @users = User.all
  end

  def user_details
    @user = User.find(params[:id])
    @user_details = EnrolledLesson.where(user_id: @user).paginate(page: params[:page], per_page: 10)
  end

  def teacher_details
    @user = User.find(params[:id])
    rc_teachers = @user.rc_teachers
    @review_centers = rc_teachers.map { |rc_teacher| ReviewCenter.find(rc_teacher.review_center_id) }.uniq

    teacher_subject_ids = rc_teachers.map { |rc_teacher| rc_teacher.teacher_subjects.pluck(:id) }.flatten
    @lessons = Lesson.where(teacher_subject_id: teacher_subject_ids).paginate(page: params[:page], per_page: 10)
  end

  def pending_users
    @students = User.all.where(status: 'pending')
  end

  def pending_rc
    @review_centers = ReviewCenter.all.where(status: 'pending')
  end

  def approve_users
    @student = User.find(params[:id])
    UserMailer.confirmation_email(@student).deliver_later
    @student.update(status: 'active')
    redirect_to admin_pending_users_path, notice: 'Successfully approve student signup'
  end

  def approve_rc
    @review_center = ReviewCenter.find(params[:id])
    @review_center.update(status: 'active')
    redirect_to admin_pending_rc_path, notice: 'Successfully approve review center signup'
  end

  def review_center_list
    @review_centers = ReviewCenter.all
  end

  def rc_details
    @user = ReviewCenter.find(params[:id])
    rc_courses = @user.rc_courses
    @rc_details = rc_courses.map { |rc_course| rc_course.lessons.first(5) }.flatten

    @rc_teachers = @user.rc_teachers
    teacher_subject_ids = @rc_teachers.map { |rc_teacher| rc_teacher.teacher_subjects.pluck(:id) }.flatten
    @lessons = Lesson.where(teacher_subject_id: teacher_subject_ids).paginate(page: params[:page], per_page: 10)
  end

  def transactions
    @transactions = Transaction.all
  end

  private

  def required_admin
    return if current_user.type == 'Admin'

    redirect_to root_path, alert: 'You are not authorized to perform this action'
  end
end
