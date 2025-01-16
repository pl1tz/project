Rails.application.config.middleware.insert_before 0, Rack::Runtime do
  Class.new do
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      
      # Добавляем заголовки для кэширования
      headers['Cache-Control'] ||= 'public, max-age=31536000'
      headers['Expires'] = 1.year.from_now.httpdate
      headers['Pragma'] = 'public'
      
      # Добавляем заголовки для оптимизации Safari
      headers['X-Content-Type-Options'] = 'nosniff'
      headers['X-Frame-Options'] = 'DENY'
      headers['X-XSS-Protection'] = '1; mode=block'
      
      [status, headers, response]
    end
  end
end 