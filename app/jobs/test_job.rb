class TestJob
  include Sidekiq::Job

  def perform
    puts "[#{Time.now}] Я выполняюсь по расписанию!"
  end
end
