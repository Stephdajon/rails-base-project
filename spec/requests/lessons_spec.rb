require 'rails_helper'

RSpec.describe 'Lessons', type: :request do
  let!(:teacher) { create(:teacher) }
  let!(:course) { create(:course) }
  let!(:subject1) { create(:subject, course: course) }
  let!(:review_center) { create(:review_center) }
  let!(:rc_course) { create(:rc_course, review_center: review_center, course: course) }

  def rc_teacher
    build(:rc_teacher, review_center: review_center, user_id: teacher.id)
  end

  def teacher_subject
    rc_teacher.save
    create(:teacher_subject, rc_teacher: RcTeacher.first, subject_id: subject1.id, rc_course: rc_course)
  end

  def lesson
    build(:lesson, teacher_subject: teacher_subject, rc_course: rc_course)
  end

  before do
    teacher_subject

    sign_in teacher, scope: :user
  end

  describe 'GET index' do
    it 'has a success status' do
      get rc_lessons_path(review_center)
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root path user is not authorized' do
      sign_out teacher
      get rc_lessons_path(review_center)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET :rc_course/lessons/new' do
    it 'has a success status' do
      get new_rc_lesson_path(review_center)
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root path user is not authorized' do
      sign_out teacher
      get new_rc_lesson_path(review_center)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST :rc_course/lessons/' do
    subject(:unauthorized_user) { Teacher.create(username: 'unauthorized', firstname: 'unauthorized', lastname: 'unauthorized', email: 'unauthorized@email.com', password: 'password', password_confirmation: 'password') }

    it 'redirects to index after create' do
      post rc_lessons_path(review_center), params: { lesson: { name: lesson.name, details: lesson.details, teacher_subject_id: lesson.teacher_subject_id, rc_course_id: lesson.rc_course_id, price: lesson.price }, format: :js }
      expect(response).to redirect_to(rc_lessons_path(review_center))
    end

    it 'renders :rc_course/lessons/new if creation fails' do
      post rc_lessons_path(review_center), params: { lesson: { name: nil, details: nil, teacher_subject_id: lesson.teacher_subject_id, rc_course_id: lesson.rc_course_id, price: nil }, format: :js }
      expect(response).to render_template(:errors)
    end

    it 'does not create a lesson if user is not authorized' do
      sign_out teacher
      sign_in unauthorized_user, scope: :user
      expect { post rc_lessons_path(review_center), params: { lesson: { name: lesson.name, details: lesson.details, teacher_subject_id: lesson.teacher_subject_id, rc_course_id: lesson.rc_course_id, price: lesson.price }, format: :js } }.to change(Lesson, :count).by(0)
    end

    it 'redirects if user is not authorized' do
      sign_out teacher
      sign_in unauthorized_user, scope: :user
      post rc_lessons_path(review_center), params: { lesson: { name: lesson.name, details: lesson.details, teacher_subject_id: lesson.teacher_subject_id, rc_course_id: lesson.rc_course_id, price: lesson.price }, format: :js }
      expect(response).to redirect_to(root_path)
    end

    it 'does not create a lesson if user is not authenticated' do
      sign_out teacher
      expect { post rc_lessons_path(review_center), params: { lesson: { name: lesson.name, details: lesson.details, teacher_subject_id: lesson.teacher_subject_id, rc_course_id: lesson.rc_course_id, price: lesson.price }, format: :js } }.to change(Lesson, :count).by(0)
    end

    it 'redirects to root path if user is not authenticated' do
      sign_out teacher
      post rc_lessons_path(review_center), params: { lesson: { name: lesson.name, details: lesson.details, teacher_subject_id: lesson.teacher_subject_id, rc_course_id: lesson.rc_course_id, price: lesson.price }, format: :js }
      expect(response).to redirect_to(root_path)
    end
  end
end
