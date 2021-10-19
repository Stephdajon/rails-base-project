class CheckoutController < ApplicationController
  before_action :authenticate_user!
  # before_action :required_students

  def create
    @lesson = Lesson.find(params[:id])

    return redirect_to root_path if @lesson.nil?

    @enrolled_lesson = EnrolledLesson.find_by(user_id: current_user.id, lesson_id: @lesson.id)

    return redirect_to lesson_details_path(@lesson.teacher_subject.subject.name.split.join, @lesson.teacher_subject.subject.course_id, @lesson.id), alert: "You already buy this #{@lesson.name} lesson" if @enrolled_lesson

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: @lesson.name,
        description: @lesson.details,
        amount: @lesson.price.to_i,
        currency: 'usd',
        quantity: 1
      }],
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}&lesson_id=#{@lesson.id}",
      cancel_url: checkout_cancel_url
    )

    respond_to do |format|
      format.js
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @lesson = Lesson.find(params[:lesson_id])

    @transaction = Transaction.new
    @transaction.name = @lesson.name
    @transaction.details = @lesson.details
    @transaction.reference_number = @session.payment_intent
    @transaction.price = @lesson.price
    @transaction.user_id = current_user.id
    @transaction.lesson_id = @lesson.id

    @payment = Payment.new
    @payment.name = @lesson.name
    @payment.details = @lesson.details
    @payment.price = @lesson.price
    @payment.reference_number = @session.payment_intent
    @payment.user_id = current_user.id
    @payment.lesson_id = @lesson.id

    return unless @transaction.save && @payment.save

    @enrolled_lesson = EnrolledLesson.new
    @enrolled_lesson.title = @lesson.name
    @enrolled_lesson.description = @lesson.details
    @enrolled_lesson.price = @lesson.price
    @enrolled_lesson.user_id = current_user.id
    @enrolled_lesson.lesson_id = @lesson.id

    redirect_to my_lessons_path, notice: 'Successfully buy a lesson' if @enrolled_lesson.save
    @user_cart = UserCart.find_by(user_id: current_user.id, lesson_id: @lesson.id)

    return @user_cart.destroy if @user_cart
  end

  # private

  # def required_students
  #   return if current_user.type == 'Student'

  #   redirect_to root_path, alert: 'You are not authorized to perform this action'
  # end

end
