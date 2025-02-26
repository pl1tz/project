class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def run_task
    task_name = params[:task]

    # Проверка, выполняется ли хотя бы одна задача
    if Task.exists?(status: 'running')
      render json: { error: "Другая задача уже выполняется. Подождите завершения." }, status: :unprocessable_entity
      return
    end

    if task_name.present?
      # Создаём запись о задаче со статусом 'running'
      task = Task.create(name: task_name, status: 'running')

      # Запуск rake задачи
      result = system("bundle exec rake #{task_name}")

      # Обновляем статус задачи после завершения
      task.update(status: result ? 'completed' : 'failed')

      if result
        render json: { message: "Задача #{task_name} успешно завершена" }, status: :ok
      else
        render json: { error: "Ошибка при запуске задачи #{task_name}" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Не указано имя задачи" }, status: :bad_request
    end
  end
end
