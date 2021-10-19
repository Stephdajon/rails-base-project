class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :required_admin

  def index; end

  private

  def required_admin
    return if current_user.type == 'Admin'

    # if current_user.type == 'Teacher'
    #   redirect_to rc_lessons_path(1), alert: 'You are not authorized to perform this action'
    # elsif current_user.type == 'Student'
    #   redirect_to root_path, alert: 'You are not authorized to perform this action'
    # end
  end
end
