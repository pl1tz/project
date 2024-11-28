class UpdateImagesService
  def initialize(images_params)
    @images_params = images_params
  end

  def call
    @images_params.each do |image_params|
      if image_params[:id].present?
        # Обновление существующей записи
        image = Image.find_by(id: image_params[:id])
        image.update(
          car_id: image_params[:car_id],
          url: image_params[:url]
        ) if image
      else
        # Создание новой записи
        Image.create(
          car_id: image_params[:car_id],
          url: image_params[:url]
        )
      end
    end
  end
end