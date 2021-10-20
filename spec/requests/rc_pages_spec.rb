require 'rails_helper'

RSpec.describe 'RcPages', type: :request do
  let!(:review_center) { create(:review_center) }

  describe 'GET /reviewcenter/teachers' do
    it 'has a success status' do
      sign_in review_center, scope: :review_center
      get teachers_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /reviewcenter/teachers/invitations' do
    it 'has a success status' do
      sign_in review_center, scope: :review_center
      get rc_teachers_invitations_path
      expect(response).to have_http_status(:ok)
    end
  end
end
