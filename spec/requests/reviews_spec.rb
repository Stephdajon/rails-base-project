require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let!(:teacher) { create(:teacher) }
  let!(:subject1) { create(:subject, course: course) }
  let!(:review_center) { create(:review_center) }
  let!(:rc_course) { create(:rc_course, review_center: review_center, course: course) }
  let!(:student) { create(:student) }

  def course
    create(:course)
  end

  def review
    build(:review)
  end

  def rc_teacher
    build(:rc_teacher, review_center_id: ReviewCenter.first.id, user_id: teacher.id)
  end

  def teacher_subject
    rc_teacher.save
    create(:teacher_subject, rc_teacher: RcTeacher.first, subject_id: subject1.id, rc_course: rc_course)
  end

  def video
    Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample_video2.mp4'), 'video/mp4')
  end

  def thumbnail
    Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/img4.jpg'), 'image/jpg')
  end

  def lesson
    create(:lesson, teacher_subject: teacher_subject, rc_course: rc_course, video: video, thumbnail: thumbnail)
  end

  before do
    sign_in student, scope: :user
  end

  describe 'GET index' do
    it 'has a success status' do
      get reviews_path(lesson)
      expect(response).to have_http_status(:ok)
    end
  end

  it 'redirects to session path if user is not authenticated' do
    sign_out student
    get reviews_path(lesson)
    expect(response).to redirect_to(new_user_session_path)
  end

  describe 'redirect to :rc_course/lessons/new' do
    it 'has a success status' do
      get new_review_path(lesson)
      expect(response).not_to have_http_status(:ok)
    end

    it 'redirects to session path if user is not authenticated' do
      sign_out student
      get new_review_path(lesson)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  it 'creates a lesson' do
    expect { post create_review_path(lesson), params: { review: { rating: review.rating, comment: review.comment } } }.to change(Review, :count).by(1)
  end
end
