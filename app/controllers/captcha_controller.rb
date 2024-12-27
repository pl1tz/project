class CaptchaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def verify
    unless verify_recaptcha(response: params[:captcha_token])
      render json: { error: 'Invalid captcha' }, status: :unprocessable_entity
      return
    end

    render json: { success: true }, status: :ok
  end
end
