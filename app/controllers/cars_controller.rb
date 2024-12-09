class CarsController < ApplicationController
  before_action :set_car, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    per_page = 18
    filtered_cars = CarFilterService.new(filter_params, per_page).call
    paginated_cars = filtered_cars.page(params[:page]).per(params[:per_page] || per_page)

    if params[:price_asc] == 'true'
      paginated_cars = paginated_cars.order(price: :asc)
    end
    if params[:price_desc] == 'true'
      paginated_cars = paginated_cars.order(price: :desc)
    end
    if params[:mileage] == 'true'
      paginated_cars = paginated_cars.order('history_cars.last_mileage ASC')
    end
    if params[:newest] == 'true'
      paginated_cars = paginated_cars.order(year: :desc)
    end

    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    elsif params[:coll] == 'all'
      render json: filtered_cars, each_serializer: CarSerializer
    else
      render json: paginated_cars, each_serializer: CarSerializer
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
    per_page = 18
    total_pages = CarFilterService.new(filter_params, per_page).total_pages
    cars_count = CarFilterService.new(filter_params, per_page).cars_count
    render json: { total_pages: total_pages, cars_count: cars_count }
  end

  def last_cars
    @cars = Car.last(20)
    render json: @cars
  end

  def cars_count
    result = BrandModelGenerationCountService.call
    render json: result
  end

  def filters
    filters = params.permit(:brand_name, :model_name, :generation_name,
                             :year_from, :max_price, :gearbox_type_name, :body_type_name,
                             :drive_type_name, :owners_count, :engine_name_type_name) # Добавлено
    result = CarFilterDataService.call(filters)
    if params[:price_asc] == 'true'
      result = result.order(price: :asc)
    end
    if params[:price_desc] == 'true'
      result = result.order(price: :desc)
    end
    if params[:mileage] == 'true'
      result = result.order('history_cars.last_mileage ASC')
    end
    if params[:newest] == 'true'
      result = result.order(year: :desc)
    end
    render json: result
  end


  def car_details
    brand_name = params[:brand_name]
    model_name = params[:model_name]
    generation_name = params[:generation_name]
    result = CarDetailService.call(brand_name, model_name, generation_name)
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

  def special_offers
    per_page = 18
    filtered_cars = CarFilterService.new(filter_params, per_page).call.where(special_offer: true)
    paginated_cars = filtered_cars.page(params[:page]).per(params[:per_page] || per_page)

    debugger

    if params[:price_asc] == 'true'
      paginated_cars = paginated_cars.order(price: :asc)
    end
    if params[:price_desc] == 'true'
      paginated_cars = paginated_cars.order(price: :desc)
    end
    if params[:mileage] == 'true'
      paginated_cars = paginated_cars.order('history_cars.last_mileage ASC')
    end
    if params[:newest] == 'true'
      paginated_cars = paginated_cars.order(year: :desc)
    end

    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    elsif params[:coll] == 'all'
      render json: filtered_cars, each_serializer: CarSerializer
    else
      render json: paginated_cars, each_serializer: CarSerializer
    end
  end

  private

  def set_car
    @car = Car.find_by(id: params[:id])
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
