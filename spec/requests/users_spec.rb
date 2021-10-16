require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { build(:user) }
  
  describe 'session' do
    it 'gets /users/sign_in' do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
    end

    it 'renders new template if creation fails' do
      post user_session_path, params: { user: { email: '', password: user.password } }
      expect(response).to render_template(:new)
    end
  end

  describe 'registration' do
    it 'gets /users/sign_up' do
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it 'renders new template if creation fails' do
      post user_registration_path, params: { user: { email: '', password: user.password } }
      expect(response).to render_template(:new)
    end

  end
end
