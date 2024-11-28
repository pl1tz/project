class CarFilterService
  def initialize(params, per_page)
    @params = params
    @per_page = per_page || Car.count
  end

  def call
    cars = Car.all.includes(:images, :history_cars)

    cars = cars.by_brand_name(@params[:brand_name]) if @params[:brand_name].present?
    cars = cars.by_model_name(@params[:model_name]) if @params[:model_name].present?
    cars = cars.by_generation(@params[:generation_name]) if @params[:generation_name].present?

    cars = cars.by_year_from(@params[:year_from]) if @params[:year_from].present?
    cars = cars.by_price(@params[:max_price]) if @params[:max_price].present?

    cars = cars.by_gearbox_type(@params[:gearbox_type_name]) if @params[:gearbox_type_name].present?
    cars = cars.by_body_type(@params[:body_type_name]) if @params[:body_type_name].present?
    cars = cars.by_drive_type(@params[:drive_type_name]) if @params[:drive_type_name].present?

    cars = cars.by_owners_count(@params[:owners_count]) if @params[:owners_count].present?
    cars = cars.by_engine_name_type(@params[:engine_name_type_name]) if @params[:engine_name_type_name].present?


    cars
  end

  def total_pages
    total_cars = call.count
    (total_cars.to_f / @per_page).ceil
  end

  def cars_count
    call.count
  end

  def all_cars
    call.to_a
  end
 
end
