class OrdersInstallmentsService
  def initialize(params = {})
    @params = params
  end

  def call
    orders_installments = OrdersInstallment.includes(installment: { car: [:brand, :model, :generation, :color, :body_type, :engine_name_type, :engine_power_type, :engine_capacity_type, :gearbox_type, :drive_type] }).all

    orders_installments.map do |order_installment|
      format_order_installment(order_installment)
    end
  end

  private

  def format_order_installment(order_installment)
    {
      id: order_installment.id,
      description: order_installment.description,
      installment: format_installment(order_installment.installment),
      order_status: {
        id: order_installment.order_status.id,
        name: order_installment.order_status.name
      }
    }
  end

  def format_installment(installment)
    car = installment.car
    {
      id: installment.id,
      car_id: car&.id,
      name: installment.name,
      phone: installment.phone,
      credit_term: installment.credit_term,
      initial_contribution: installment.initial_contribution,
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