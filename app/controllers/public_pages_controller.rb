class PublicPagesController < ApplicationController
  def landing
    @lessons = Lesson.all

    return unless params[:search]

    @parameter = params[:search].downcase
    @results = Lesson.all.where('lower(name) LIKE :search', search: "%#{@parameter}%")

  end


end
