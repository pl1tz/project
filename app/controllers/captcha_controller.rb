# Controller for google captcha
class CaptchaController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Verifies Google reCAPTCHA token
  #
  # @param [String] captcha_token Token received from Google reCAPTCHA widget
  #
  # @return [JSON] Returns success status or error message
  #
  # @example verify(captcha_token: "03AGdBq24PBgMsJ-...")
  #
  # @example_return
  #   { success: true }
  #   { error: 'Invalid captcha' }
  def verify
    unless verify_recaptcha(response: params[:captcha_token])
      render json: { error: 'Invalid captcha' }, status: :unprocessable_entity
      return
    end

    render json: { success: true }, status: :ok
  end
end
