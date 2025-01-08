class CreditsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_credit, only: %i[ show update destroy ]

  def index
    @credits = Credit.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @credits
    end
  end

  def show
    render json: @credit  
  end

  # Creates a new credit application and sends it to Plex CRM
  #
  # @param [Hash] params Credit application parameters from the request
  #   @option params [Integer] :car_id ID of the selected car
  #   @option params [String] :name Client's name
  #   @option params [String] :phone Client's phone number
  #   @option params [Integer] :credit_term Credit term in months
  #   @option params [Decimal] :initial_contribution Initial payment amount
  #   @option params [Integer] :banks_id Selected bank ID
  #   @option params [Integer] :programs_id Selected credit program ID
  #
  # @return [JSON] Returns created credit application with order or error message
  #
  # @example POST /credits
  #   {
  #     "credit": {
  #       "car_id": 1,
  #       "name": "John Doe",
  #       "phone": "+79001234567",
  #       "credit_term": 36,
  #       "initial_contribution": 300000,
  #       "banks_id": 1,
  #       "programs_id": 1
  #     }
  #   }
  #
  # @example_return
  #   {
  #     "credit": { ... },
  #     "order_credit": { ... }
  #   }
  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @credit = Credit.new(credit_params)

    ActiveRecord::Base.transaction do
      if @credit.save 
        crm_service = PlexCrmService.new
        crm_response = crm_service.send_credit_application(@credit)
        
        unless crm_response[:success]
          raise ActiveRecord::Rollback, "Failed to send to CRM: #{crm_response[:error]}"
        end

        create_order_credit(@credit)
      else
        render json: @credit.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback => e
    render json: { error: e.message || "Failed to create credit application" }, 
           status: :unprocessable_entity
  end

  def update
    if @credit.update(credit_params)
      render json: @credit, status: :ok
    else
      render json: @credit.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @credit.destroy
      head :ok
    else
      render json: { error: "Не удалось удалить кредит" }, status: :unprocessable_entity
    end
  end

  def top_programs

    @all_banks = Bank.includes(:programs).all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @all_banks.to_json(include: :programs)
    end
  end

  private
    def set_credit
      @credit = Credit.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Кредит не найден" }, status: :not_found
    end

    def credit_params
      params.require(:credit).permit(:car_id, :name, :phone, :credit_term, :initial_contribution, :banks_id, :programs_id)
    end

    def create_order_credit(credit)
      order_credit = OrdersCredit.new(
        credit_id: credit.id,
        description: "Заявка создана и ожидает обработки",
        order_status_id: OrderStatus.find_by(name: "Новая").id
      )
      if order_credit.save
        render json: { credit: credit, order_credit: order_credit }, status: :created
      else
        render json: { credit: credit, errors: order_credit.errors }, status: :unprocessable_entity
      end
    end
end
