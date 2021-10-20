class TeachersController < ApplicationController
  before_action :authorized?, only: %i[home rc_invitations accept_invitation]
  before_action :authenticate_review_center!, only: %i[new_invitation create_invitation delete_invitation]

  def home
    @review_centers = current_user.rc_teachers.map { |rc_teacher| ReviewCenter.find(rc_teacher.review_center_id) }.uniq

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
      flash[:alert] = @rc_teacher.errors.full_messages_for(:user_id).first
      redirect_to new_invitation_path
    end
  end

  def search
    @teachers = if params[:username].present?
                  Teacher.where('username like ?', "%#{params[:username]}%").limit(5)
                else
                  []
                end

    respond_to do |format|
      format.js
    end
  end

  def rc_invitations
    @rc_teacher_invitations = current_user.rc_teachers.where(status: 'pending')
  end

  def accept_invitation
    @rc_teacher = RcTeacher.find(params[:id])
    redirect_to teacher_home_path, notice: 'Invitation has been accepted.' if @rc_teacher.update(status: 'approved')
  end

  def reject_invitation
    @rc_teacher = RcTeacher.find(params[:id])
    redirect_to invitations_path, notice: 'Invitation has been rejected.' if @rc_teacher.update(status: 'rejected')
  end

  def delete_invitation
    @rc_teacher = RcTeacher.find_by(id: params[:id], status: 'pending')
    redirect_to rc_teachers_invitations_path, notice: 'Invitation has been deleted.' if @rc_teacher.destroy
  end

  private

  def new_invitation_params
    params.require(:rc_teacher).permit(:user_id, :review_center_id, :status)
  end

  def authorized?
    return redirect_to root_path, alert: 'Unauthorized Action' unless current_user && current_user.type == 'Teacher'
  end
end
