class OrdersCallRequestsService
  def initialize(params = {})
    @params = params
  end

  def call
    orders_call_requests = OrdersCallRequest.includes(call_request: { car: [:brand, :model, :generation, :color, :body_type, :engine_name_type, :engine_power_type, :engine_capacity_type, :gearbox_type, :drive_type] }).all

    orders_call_requests.map do |order_call_request|
      format_order_call_request(order_call_request)
    end
  end

  private

  def format_order_call_request(order_call_request)
    {
      id: order_call_request.id,
      description: order_call_request.description,
      call_request: format_call_request(order_call_request.call_request),
      order_status: {
        id: order_call_request.order_status.id,
        name: order_call_request.order_status.name
      }
    }
  end

  def format_call_request(call_request)
    car = call_request.car
    {
      id: call_request.id,
      car_id: car&.id,
      name: call_request.name,
      phone: call_request.phone,
      preferred_time: call_request.preferred_time,
      created_at: call_request.created_at,
      updated_at: call_request.updated_at,
      car_details: car ? format_car(car) : nil
    }
  end

  def format_car(car)
    {
      id: car.id,
      year: car.year,
      price: car.price,
      description: car.description,
      online_view_available: car.online_view_available,
      complectation_name: car.complectation_name,
      brand: {
        id: car.brand.id,
        name: car.brand.name,
        created_at: car.brand.created_at,
        updated_at: car.brand.updated_at
      },
      model: {
        id: car.model.id,
        name: car.model.name,
        brand_id: car.model.brand_id,
        created_at: car.model.created_at,
        updated_at: car.model.updated_at
      },
      generation: {
        id: car.generation.id,
        name: car.generation.name,
        model_id: car.generation.model_id,
        created_at: car.generation.created_at,
        updated_at: car.generation.updated_at
      },
      color: {
        id: car.color.id,
        name: car.color.name,
        created_at: car.color.created_at,
        updated_at: car.color.updated_at
      },
      body_type: {
        id: car.body_type.id,
        name: car.body_type.name,
        created_at: car.body_type.created_at,
        updated_at: car.body_type.updated_at
      },
      engine_name_type: {
        id: car.engine_name_type.id,
        name: car.engine_name_type.name
      },
      engine_power_type: {
        id: car.engine_power_type.id,
        power: car.engine_power_type.power
      },
      engine_capacity_type: {
        id: car.engine_capacity_type.id,
        capacity: car.engine_capacity_type.capacity
      },
      gearbox_type: {
        id: car.gearbox_type.id,
        name: car.gearbox_type.name,
        abbreviation: car.gearbox_type.abbreviation
      },
      drive_type: {
        id: car.drive_type.id,
        name: car.drive_type.name,
        created_at: car.drive_type.created_at,
        updated_at: car.drive_type.updated_at
      },
      # Добавьте дополнительные поля, если необходимо
    }
  end
end 