class ApplicationController < ActionController::Base
  # Só pede autenticação fora das telas do Devise e da landing pública
  before_action :authenticate_user!, unless: -> { devise_controller? || skip_auth? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
  end

  # Controllers que são públicos declaram: skip_before_action :authenticate_user! (já tratamos com skip_auth?).
  def skip_auth?
    false
  end
end
