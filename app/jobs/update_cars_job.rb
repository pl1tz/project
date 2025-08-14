# frozen_string_literal: true

class UpdateCarsJob
  include Sidekiq::Job

  def perform
    service = ImportCarsService.new

    Rails.logger.info("[#{Time.now}] [update_cars] Запуск обновления машшин UpdateCarsJob")
    service.update_cars

    Rails.logger.info("[#{Time.now}] [delete_diff_cars] Запуск удаления машшин UpdateCarsJob")
    service.delete_diff_cars
  end
end
