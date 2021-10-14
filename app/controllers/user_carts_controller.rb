class UserCartsController < ApplicationController
  before_action :authenticate_user!
  before_action :required_students, only: [:user_carts]
  def user_carts
    @user_carts = UserCart.where(user_id: current_user.id)
  end

  def add_to_cart
    cart = UserCart.new
    cart.user_id = current_user.id
    cart.lesson_id = params[:lesson_id]
    lesson = Lesson.find(params[:lesson_id])

    if cart.save
      redirect_to user_carts_path, notice: 'Successfully add to cart lesson'
    else
      redirect_to lesson_details_path(lesson.teacher_subject.subject.name.split.join, lesson.teacher_subject.subject.course_id, lesson.id), alert: cart.errors.messages[:lesson_id][0]
    end
  end

  def remove_to_cart
    @cart = UserCart.find_by(user_id: current_user, id: params[:user_cart_id])
    @cart.destroy
    redirect_to user_carts_path, notice: 'successfully remove to cart'
  end

  private

  def required_students
    return if current_user.type == 'Student'

    flash[:alert] = 'You are not authorized to perform this action'
    redirect_to root_path
  end
end
