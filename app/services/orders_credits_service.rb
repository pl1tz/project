class OrdersCreditsService
  def initialize(params = {})
    @params = params
  end

  def call
    orders_credits = OrdersCredit.includes(credit: { car: [:brand, :model, :generation, :color, :body_type, :engine_name_type, :engine_power_type, :engine_capacity_type, :gearbox_type, :drive_type], bank: [], program: [] }).all

    orders_credits.map do |order_credit|
      format_order_credit(order_credit)
    end
  end

  private

  def format_order_credit(order_credit)
    {
      id: order_credit.id,
      description: order_credit.description,
      credit: format_credit(order_credit.credit),
      order_status: {
        id: order_credit.order_status.id,
        name: order_credit.order_status.name
      },
      bank: order_credit.credit.banks_id.present? ? format_bank(Bank.find(order_credit.credit.banks_id)) : nil,
      program: order_credit.credit.programs_id.present? ? format_program(Program.find(order_credit.credit.programs_id)) : nil
    }
  end

  def format_credit(credit)
    car = credit.car
    {
      id: credit.id,
      car_id: car&.id,
      name: credit.name,
      phone: credit.phone,
      credit_term: credit.credit_term,
      initial_contribution: credit.initial_contribution,
      banks_id: credit.banks_id,
      programs_id: credit.programs_id,
      car_details: car ? format_car(car) : nil,
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

  def format_bank(bank)
    return nil unless bank
    {
      id: bank.id,
      name: bank.name,
      # Добавьте другие необходимые поля
    }
  end

  def format_program(program)
    return nil unless program
    {
      id: program.id,
      name: program.program_name,
      # Добавьте другие необходимые поля
    }
  end
end 