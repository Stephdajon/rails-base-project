require 'rails_helper'

RSpec.describe 'TeacherSubjects', type: :request do
  let!(:teacher) { create(:teacher) }
  let!(:course) { create(:course) }
  let!(:subject1) { create(:subject, course: course) }
  let!(:review_center) { create(:review_center) }
  let!(:rc_teacher) { create(:rc_teacher, review_center: review_center, user_id: teacher.id) }

  def rc_course
    create(:rc_course, review_center: review_center, course: course)
  end

  def review_center2
    ReviewCenter.create(email: 'rc2@email.com', name: 'string2', password: 'password', password_confirmation: 'password')
  end

  def subject2
    Subject.create(name: 'String2', course_id: course.id)
  end

  def subject_is_present_on_teacher_subject
    create(:teacher_subject, rc_teacher: rc_teacher, rc_course: RcCourse.first, subject: subject2)
  end

  before do
    rc_course
    sign_in review_center, scope: :review_center
  end

  describe 'GET new_teacher_subject_path' do
    it 'has a success status' do
      get new_teacher_subject_path(rc_teacher)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create_teacher_subject_path' do
    subject(:rc_teacher_not_associated) { RcTeacher.create(user_id: teacher.id, review_center_id: review_center2.id, status: 'approved') }

    it 'creates a teacher_subject' do
      expect { post create_teacher_subject_path(rc_teacher), params: { teacher_subject: { rc_teacher_id: rc_teacher.id, rc_course_id: rc_course.id, subject_id: [subject1.id] } } }.to change(TeacherSubject, :count).by(1)
    end

    it 'does not create teacher_subject if subject is already assigned' do
      subject2
      subject_is_present_on_teacher_subject
      expect { post create_teacher_subject_path(rc_teacher), params: { teacher_subject: { rc_teacher_id: rc_teacher.id, rc_course_id: rc_course.id, subject_id: [Subject.last.id] } } }.to change(TeacherSubject, :count).by(0)
    end

    it 'does not create teacher_subject if user is not authorized' do
      sign_out review_center
      expect { post create_teacher_subject_path(rc_teacher), params: { teacher_subject: { rc_teacher_id: rc_teacher.id, rc_course_id: rc_course.id, subject_id: [subject1.id] } } }.to change(TeacherSubject, :count).by(0)
    end

    it 'does not create teacher_subject if rc_teacher is not associated with review center' do
      expect { post create_teacher_subject_path(rc_teacher_not_associated), params: { teacher_subject: { rc_teacher_id: rc_teacher_not_associated.id, rc_course_id: rc_course.id, subject_id: [subject1.id] } } }.to change(TeacherSubject, :count).by(0)
    end

    it 'redirects to new_teacher_subject_path if no subject is selected.' do
      post create_teacher_subject_path(rc_teacher)
      expect(response).to redirect_to(new_teacher_subject_path(rc_teacher))
    end
  end
end
