# frozen_string_literal: true

class ReviewCenters::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params
  # before_action :configure_account_update_params

  before_action :configure_permitted_parameters

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        # UserMailer.welcome_email(resource).deliver_later
        sign_out(resource)
        respond_with resource, location: new_review_center_session_path
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :firstname, :lastname])
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end

  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: %i[name email password current_password])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
