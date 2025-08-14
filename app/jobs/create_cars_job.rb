# frozen_string_literal: true

class CreateCarsJob
  include Sidekiq::Job

  def perform
    service = ImportCarsService.new

    Rails.logger.info("[#{Time.now}] [update_cars] Запуск обновления машшин CreateCarsJob")
    service.create_cars

    Rails.logger.info("[#{Time.now}] [delete_diff_cars] Запуск удаления машшин CreateCarsJob")
    service.delete_diff_cars
  end
end
