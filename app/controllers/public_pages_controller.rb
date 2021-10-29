class PublicPagesController < ApplicationController
  def landing
    @lessons_by_ratings = Lesson.joins(:reviews).select('lessons.*, avg(reviews.rating) as average_rating').group('lessons.id').order('average_rating DESC')
    # TODO: Will enhance this query above
    @lessons = Lesson.all
    @lessons_by_review_counts = Lesson.all.includes(:reviews).sort_by { |review| review.reviews.count }.reverse
    @all_new_lessons = Lesson.all.order('created_at DESC')
    @all_old_lessons = Lesson.all.order('created_at ASC')
    return unless params[:search]

    @parameter = params[:search].downcase
    @results = Lesson.where("lower (lessons.name) ILIKE :value OR
                       lower (lessons.details) ILIKE :value ",
                            value: "%#{@parameter}%")
  end
end
