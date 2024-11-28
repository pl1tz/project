class UpdateExtrasService
  def initialize(extras_params)
    @extras_params = extras_params
  end

  def call
    @extras_params.each do |extra_params|
      if extra_params[:id].present?
        # Обновление существующей записи
        extra = Extra.find_by(id: extra_params[:id])
        extra.update(
          car_id: extra_params[:car_id],
          category_id: extra_params[:category_id],
          extra_name_id: extra_params[:extra_name_id]
        ) if extra
      else
        # Создание новой записи
        Extra.create(
          car_id: extra_params[:car_id],
          category_id: extra_params[:category_id],
          extra_name_id: extra_params[:extra_name_id]
        )
      end
    end
  end
end 