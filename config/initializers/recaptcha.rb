# This initializer configures Google reCAPTCHA integration for the application
# It sets up the necessary API keys required for reCAPTCHA functionality
# The keys are stored in environment variables for security:
# - RECAPTCHA_SITE_KEY: Public key used in frontend
# - RECAPTCHA_SECRET_KEY: Private key used for server-side verification
Recaptcha.configure do |config|
  config.site_key = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
end
