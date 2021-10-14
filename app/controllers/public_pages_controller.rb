class PublicPagesController < ApplicationController
  def landing
    @lessons = Lesson.all
  end
end
