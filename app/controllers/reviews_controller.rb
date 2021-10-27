class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_lesson
  before_action :required_buy, only: [:new]

  def index
    @review_lesson = Lesson.find(@lesson.id)
    @reviews = @review_lesson.reviews
  end

  def review; end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.lesson_id = @lesson.id
    @review.user_id = current_user.id

    if @review.save
      redirect_to reviews_path, notice: 'Successfully add reviews to this lesson'
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating)
  end

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def required_buy
    lesson = EnrolledLesson.find_by(user_id: current_user.id, lesson_id: @lesson.id)
    return if lesson

    redirect_to lesson_details_path(@lesson.teacher_subject.subject.name.split.join, @lesson.teacher_subject.subject.course_id, @lesson.id), alert: 'Buy first to add a reviews'
  end
end
