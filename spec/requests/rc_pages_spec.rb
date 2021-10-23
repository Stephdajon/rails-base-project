require 'rails_helper'

RSpec.describe 'RcPages', type: :request do
  let!(:review_center) { create(:review_center) }
  let!(:course) { create(:course) }
  let!(:rc_course) { create(:rc_course, review_center: review_center, course: course) }
  let!(:subject1) { create(:subject, course: course) }
  let!(:teacher) { create(:teacher) }

  def rc_teacher
    build(:rc_teacher, review_center: review_center, user_id: teacher.id)
  end

  def teacher_subject
    rc_teacher.save
    create(:teacher_subject, rc_teacher: RcTeacher.first, subject_id: subject1.id, rc_course: rc_course)
  end

  before do
    sign_in review_center, scope: :review_center
  end

  describe 'GET root path' do
    it 'has a success status' do
      get authenticated_rc_root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /reviewcenter/teachers' do
    it 'has a success status' do
      get teachers_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET rc_teacher_invitations_path' do
    it 'has a success status' do
      get rc_teachers_invitations_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET rc_course_path' do
    it 'has a success status' do
      get rc_course_path(rc_course)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET rc_subject_path' do
    it 'has a success status' do
      get rc_subject_path(rc_course, subject1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET rc_lesson_path' do
    subject(:lesson) do
      lesson = Lesson.new(name: 'Lesson', details: 'Lesson Details', price: 100, teacher_subject_id: teacher_subject.id, rc_course_id: rc_course.id)
      lesson.video = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample_video2.mp4'), 'video/mp4')
      lesson.thumbnail = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/img4.jpg'), 'image/jpg')
      lesson.save
    end

    it 'has a success status' do
      lesson
      get rc_lesson_path(rc_course, subject1, Lesson.first)
      expect(response).to have_http_status(:ok)
    end
  end
end
