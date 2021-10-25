require 'rails_helper'

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

    it 'does not create a rc_teacher if record already exist and status is approved' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'approved')

      sign_in review_center, scope: :review_center
      expect { post create_invitation_path, params: { rc_teacher: { username: teacher.username, review_center_id: review_center.id, status: 'pending' } } }.to change(RcTeacher, :count).by(0)
    end

    it 'does not create a rc_teacher if invitation already exist and status is pending' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'pending')

      sign_in review_center, scope: :review_center
      expect { post create_invitation_path, params: { rc_teacher: { username: teacher.username, review_center_id: review_center.id, status: 'pending' } } }.to change(RcTeacher, :count).by(0)
    end

    it 'does not create a rc_teacher if invitation already exist and status is rejected' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'rejected')

      sign_in review_center, scope: :review_center
      expect { post create_invitation_path, params: { rc_teacher: { username: teacher.username, review_center_id: review_center.id, status: 'pending' } } }.to change(RcTeacher, :count).by(0)
    end
  end

  describe 'gets /teacher/invitations' do
    it 'has a success status' do
      sign_in teacher, scope: :user
      get invitations_path
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to root path if teacher is not signed in' do
      get invitations_path
      expect(response).to redirect_to(root_path)
    end

    it 'updates rc_teacher status to "approved"' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'pending')
      sign_in teacher, scope: :user
      patch accept_invitation_path(RcTeacher.first)
      expect(response).to redirect_to(teacher_home_path)
    end

    it 'updates rc_teacher status to "rejected"' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'pending')
      sign_in teacher, scope: :user
      patch reject_invitation_path(RcTeacher.first)
      expect(response).to redirect_to(invitations_path)
    end
  end

  describe 'deletes invitations' do
    it 'deletes rc_teacher object' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'pending')
      sign_in review_center, scope: :review_center
      expect { delete delete_invitation_path(RcTeacher.first) }.to change(RcTeacher, :count).by(-1)
    end
  end

  describe 'resend invitation' do
    it 'updates status to "pending"' do
      create(:rc_teacher, user_id: teacher.id, review_center: review_center, status: 'rejected')
      sign_in review_center, scope: :review_center
      patch resend_invitation_path(RcTeacher.first)
      expect(RcTeacher.first.status).to eq('pending')
    end
  end
end
