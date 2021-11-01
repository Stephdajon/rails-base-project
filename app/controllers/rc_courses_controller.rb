class RcCoursesController < ApplicationController
  before_action :authenticate_review_center!
  before_action :selected_courses?, only: :create

  def new
    @courses = Course.all.order(:name)
    @rc_course = current_review_center.rc_courses.build
  end

  def create
    course_ids = params[:rc_course][:course_id]

    course_ids.each do |course_id|
      existing_rc_course = current_review_center.rc_courses.find_by(course_id: course_id)
      next if existing_rc_course.present?

      rc_course = current_review_center.rc_courses.build(rc_course_params)
      rc_course.course_id = course_id
      rc_course.save
    end
    redirect_to authenticated_rc_root_path, notice: 'Successfully added courses.'
  end

  private

  def rc_course_params
    params.require(:rc_course).permit(:review_center_id, course_id: [])
  end

  def selected_courses?
    return redirect_to new_rc_course_path, alert: 'Atleast one course must be selected.' if params[:rc_course].nil?
  end
end
