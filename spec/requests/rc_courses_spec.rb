require 'rails_helper'

RSpec.describe 'RcCourses', type: :request do
  let!(:course) { create(:course) }
  let!(:review_center) { create(:review_center) }
  let!(:course_not_yet_added) { Course.create(name: 'String1') }
  let!(:course_not_yet_added2) { Course.create(name: 'String2') }

  before do
    sign_in review_center, scope: :review_center
  end

  describe 'GET /review_center/rccourses' do
    it 'has a success status' do
      get new_rc_course_path
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root path if review center is not authenticated' do
      sign_out review_center
      get new_rc_course_path
      expect(response).to redirect_to(new_review_center_session_path)
    end
  end

  describe 'POST create_rc_course_path' do
    subject(:rc_course) { create(:rc_course, review_center: review_center, course: course) }

    it 'creates a rc_course' do
      expect { post create_rc_course_path, params: { rc_course: { review_center_id: review_center.id, course_id: [course_not_yet_added.id] } } }.to change(RcCourse, :count).by(1)
    end

    it 'does not create rc_course if course is already added' do
      rc_course
      expect { post create_rc_course_path, params: { rc_course: { review_center_id: review_center.id, course_id: [course.id] } } }.to change(RcCourse, :count).by(0)
    end

    it 'does not create teacher_subject if user is not authenticated' do
      sign_out review_center
      expect { post create_rc_course_path, params: { rc_course: { review_center_id: review_center.id, course_id: [course_not_yet_added.id] } } }.to change(RcCourse, :count).by(0)
    end

    it 'creates multiple teacher_subjects' do
      expect { post create_rc_course_path, params: { rc_course: { review_center_id: review_center.id, course_id: [course_not_yet_added.id, course_not_yet_added2.id] } } }.to change(RcCourse, :count).by(2)
    end

    it 'redirects to new if no course is selected' do
      post create_rc_course_path
      expect(response).to redirect_to(new_rc_course_path)
    end
  end
end
