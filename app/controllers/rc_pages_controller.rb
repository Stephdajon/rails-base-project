class RcPagesController < ApplicationController
  before_action :authenticate_review_center!

  def home; end

  def teachers
    @rc_teachers = current_review_center.rc_teachers
  end

  def teacher_invitations
    @rc_teachers_invitations = current_review_center.rc_teachers.where(status: 'pending')
  end

  def approve_teacher; end
end
