class TeachersController < ApplicationController
  before_action :authorized?

  def home
    @review_centers = current_user.rc_teachers.map { |rc_teacher| ReviewCenter.find(rc_teacher.review_center_id) }

    teacher_subject_ids = current_user.rc_teachers.map { |rc_teacher| rc_teacher.teacher_subjects.pluck(:id) }.flatten
    @lessons = Lesson.where(teacher_subject_id: teacher_subject_ids)
  end

  def invite_teacher; end

  def rc_invitations; end

  def accept_invitations; end

  private

  def authorized?
    authenticate_user!
    redirect_to root_path unless current_user.teacher?
  end
end
