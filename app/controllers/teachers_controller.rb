class TeachersController < ApplicationController
  before_action :authorized?, only: %i[home rc_invitations accept_invitations]
  before_action :authenticate_review_center!, only: %i[new_invitation create_invitation]

  def home
    @review_centers = current_user.rc_teachers.map { |rc_teacher| ReviewCenter.find(rc_teacher.review_center_id) }

    teacher_subject_ids = current_user.rc_teachers.map { |rc_teacher| rc_teacher.teacher_subjects.pluck(:id) }.flatten
    @lessons = Lesson.where(teacher_subject_id: teacher_subject_ids)
  end

  def new_invitation
    @rc_teacher = current_review_center.rc_teachers.build
  end

  def create_invitation
    @rc_teacher = current_review_center.rc_teachers.new(new_invitation_params)
    @rc_teacher.user_id = Teacher.find_by(username: params[:rc_teacher][:username])&.id
    @rc_teacher.review_center_id = current_review_center.id
    @rc_teacher.status = 'pending'

    if @rc_teacher.save
      flash[:notice] = 'Successfully sent teacher invitation'
      redirect_to authenticated_rc_root_path
    else
      flash[:error] = @rc_teacher.errors.full_messages.first
      redirect_to new_invitation_path
    end
  end

  def search
    @teachers = Teacher.where('username like ?', "%#{params[:username]}%").limit(5)

    respond_to do |format|
      format.js
    end
  end

  def rc_invitations; end

  def accept_invitations; end

  private

  def new_invitation_params
    params.require(:rc_teacher).permit(:user_id, :review_center_id, :status)
  end

  def authorized?
    authenticate_user!
    redirect_to root_path unless current_user.type == 'Teacher'
  end
end
