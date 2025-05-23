class CarsController < ApplicationController
  before_action :set_car, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    per_page = 12
    filtered_cars = CarFilterService.new(filter_params, per_page).call
    paginated_cars = filtered_cars.page(params[:page]).per(params[:per_page] || per_page)

    if params[:price_asc] == 'true'
      paginated_cars = paginated_cars.order(price: :asc)
    end
    if params[:price_desc] == 'true'
      paginated_cars = paginated_cars.order(price: :desc)
    end
    if params[:mileage] == 'true'
      paginated_cars = paginated_cars.joins(:history_cars)
                                     .select('cars.id, cars.*, history_cars.last_mileage')
                                     .order('cars.id, history_cars.last_mileage ASC')
    end
    if params[:newest] == 'true'
      paginated_cars = paginated_cars.order(year: :desc)
    end

    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    elsif params[:coll] == 'all'
      render json: filtered_cars, each_serializer: CarDetailSerializer
    else
      render json: paginated_cars, each_serializer: CarDetailSerializer
    end

  end

  def show
    if @car.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      return
    end

    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @car, serializer: CarSerializer
    end
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car, status: :created
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    if @car.update(car_params)
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car, status: :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @car.destroy
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        head :ok
      end
    else
      if request.format.html?
        render file: "#{Rails.root}/public/index.html", layout: false
      else
        render json: @car.errors, status: :internal_server_error
      end
    end
  end

  def total_pages
    per_page = 12
    total_pages = CarFilterService.new(filter_params, per_page).total_pages
    cars_count = CarFilterService.new(filter_params, per_page).cars_count
    render json: { total_pages: total_pages, cars_count: cars_count }
  end

  def last_cars
    @cars = Car.includes(:brand, :model, :generation, :body_type, :engine_name_type, :engine_power_type, :engine_capacity_type, :gearbox_type, :drive_type, :history_cars, :images)
               .order(created_at: :desc)
               .limit(3)
  
    render json: @cars.map { |car|
      car.as_json(
        only: [:id, :unique_id, :year, :price, :online_view_available],
        include: {
          brand: { only: [:name] },
          model: { only: [:name] },
          generation: { only: [:name] },
          body_type: { only: [:name] },
          engine_name_type: { only: [:name] },
          engine_power_type: { only: [:power] },
          engine_capacity_type: { only: [:capacity] },
          gearbox_type: { only: [:abbreviation] },
          drive_type: { only: [:name] },
          history_cars: { only: [:last_mileage, :previous_owners] }
        }
      ).merge(images: car.images.limit(4).map { |img| { url: img.url } })
    }
  end  

  def cars_count
    result = BrandModelGenerationCountService.call
    render json: result
  end

  def filters
    filters = params.permit(:brand_name, :model_name, :generation_name,
                             :year_from, :max_price, :gearbox_type_name, :body_type_name,
                             :drive_type_name, :owners_count, :engine_name_type_name)
    if params[:price_asc] == 'true'
      paginated_cars = paginated_cars.order(price: :asc)
    end
    if params[:price_desc] == 'true'
      paginated_cars = paginated_cars.order(price: :desc)
    end
    if params[:mileage] == 'true'
      paginated_cars = paginated_cars.joins(:history_cars).order('history_cars.last_mileage ASC')
    end
    if params[:newest] == 'true'
      paginated_cars = paginated_cars.order(year: :desc)
    end
    result = CarFilterDataService.call(filters)
    render json: result
  end


  def car_details
    result = CarFilterService.new(filter_params, 10).call
    render json: result
  end

  def car_ids
    result = CarIdsService.new(filter_params).call
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: result
    end
  end

  def download_pdf
    car = Car.find(params[:id])
    pdf = generate_pdf(car) # Метод для генерации PDF

    send_data pdf.render, filename: "#{car.brand}_#{car.id}.pdf", type: 'application/pdf', disposition: 'attachment'
  end

  def add_car
    render file: "#{Rails.root}/public/index.html", layout: false
  end

  private
    def set_car
      @car = Car.find_by(unique_id: params[:unique_id])
      if @car.nil?
        render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
      end
    end

    def car_params
      params.require(:car).permit(:model_id, :brand_id, :year, :price, :description,
                                  :color_id, :body_type_id, :engine_name_type_id, :engine_power_type_id, :engine_capacity_type_id, :gearbox_type_id,
                                  :drive_type_id, :generation_id, :online_view_available, :complectation_name)
    end

    def filter_params
      params.permit(:id, :brand_name, :model_name, :generation_name,
                    :year_from, :max_price, :gearbox_type_name, :body_type_name,
                    :drive_type_name, :owners_count, :engine_name_type_name, :unique_id)
    end

  def generate_pdf(car)
    # Логика для генерации PDF
    Prawn::Document.new do |pdf|
      pdf.text "Details for #{car.brand}"
      # Добавьте другие детали автомобиля
    end
  end
end
