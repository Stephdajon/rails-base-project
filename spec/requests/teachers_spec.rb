# require 'rails_helper'

RSpec.describe 'Teachers', type: :request do
  let!(:teacher) { create(:teacher) }
  let!(:review_center) { create(:review_center) }

  describe 'GET /home' do
    it 'has a success status' do
      sign_in teacher, scope: :user
      get teacher_home_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'invites a teacher' do
    it 'has a success status' do
      sign_in review_center, scope: :review_center
      get new_invitation_path
      expect(response).to have_http_status(:ok)
    end

    it 'creates rc_teacher with pending status' do
      sign_in review_center, scope: :review_center
      expect { post create_invitation_path, params: { rc_teacher: { username: teacher.username, review_center_id: review_center.id, status: 'pending' } } }.to change(RcTeacher, :count).by(1)
    end

    it 'redirects to authenticated_rc_root after creation' do
      sign_in review_center, scope: :review_center
      post create_invitation_path, params: { rc_teacher: { username: teacher.username, review_center_id: review_center.id, status: 'pending' } }
      expect(response).to redirect_to(authenticated_rc_root_path)
    end

    it 'redirects to new_invitation path if creation fails' do
      sign_in review_center, scope: :review_center
      post create_invitation_path, params: { rc_teacher: { username: '', review_center_id: nil } }
      expect(response).to redirect_to(new_invitation_path)
    end
  end
end
