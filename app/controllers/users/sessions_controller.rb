# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    case current_user.type
    when 'Admin'
      respond_with resource, location: admin_path
    when 'Student'
      if current_user.status == 'pending'
        redirect_to new_user_session_path, notice: 'We send you an email once the admin approved your account. Thankyou for your patience.'
        sign_out resource
      else
      respond_with resource, location: root_path
      end
    when 'Teacher'
      respond_with resource, location: teacher_home_path
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
