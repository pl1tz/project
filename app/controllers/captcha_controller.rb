# require 'net/http'

# class CaptchaController < ApplicationController
#   def verify
#     Rails.logger.info("Received captcha verification request with token: #{params[:token]}")

#     token = params[:token]
#     secret_key = '6LdAFqMqAAAAAMm1WqbP92_q_Ef-xxO6md7dK-TW'

#     uri = URI('https://www.google.com/recaptcha/api/siteverify')
#     response = Net::HTTP.post_form(uri, {
#       'secret' => secret_key,
#       'response' => token
#     })

#     result = JSON.parse(response.body)

#     if result['success']
#       render json: { success: true }
#     else
#       render json: { success: false, errors: result['error-codes'] }
#     end
#   end
# end
