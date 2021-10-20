class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :required_admin

  def index; end

  def user_list
    @users = User.all
  end

  # def student_list
  #   @students = Student.all
  # end

  def pending_users
    @students = Student.all.where(status: 'pending')
  end

  def pending_rc
    @review_centers = ReviewCenter.all.where(status: 'pending')
  end

  def approve_users
    @student = Student.find(params[:id])
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

  def transactions
    @transactions = Transaction.all
  end

  private

  def required_admin
    return if current_user.type == 'Admin'
    redirect_to root_path, alert: 'You are not authorized to perform this action'
  end
end
