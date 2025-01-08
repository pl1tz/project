class BuyoutsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_buyout, only: %i[ show update destroy ]

  def index
    @buyouts = Buyout.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @buyouts
    end
  end

  def show
    render json: @buyout
  end

  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @buyout = Buyout.new(buyout_params)

    ActiveRecord::Base.transaction do
      if @buyout.save
        crm_service = PlexCrmService.new
        crm_response = crm_service.send_buyout_application(@buyout)
        
        Rails.logger.info "CRM Response: #{crm_response.inspect}"
        
        unless crm_response[:success]
          error_message = "Failed to send to CRM: #{crm_response[:message]}"
          Rails.logger.error error_message
          raise ActiveRecord::Rollback, error_message
        end

        Rails.logger.info "Successfully created buyout application and sent to CRM"
        create_order_buyout(@buyout)
      else
        Rails.logger.error "Failed to save buyout: #{@buyout.errors.full_messages}"
        render json: @buyout.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback => e
    render json: { error: e.message || "Failed to create buyout application" }, 
           status: :unprocessable_entity
  end

  def update
    if @buyout.update(buyout_params)
      render json: @buyout, status: :ok
    else
      render json: @buyout.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @buyout.destroy
      head :ok
    else
      render json: @buyout.errors, status: :unprocessable_entity
    end
  end

  private
    def set_buyout
      @buyout = Buyout.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Выкуп не найден" }, status: :not_found
    end

    def buyout_params
      params.require(:buyout).permit(:name, :phone, :brand, :model, :year, :mileage)
    end

    def create_order_buyout(buyout)
      order_buyout = OrdersBuyout.new(
        buyout_id: buyout.id,
        description: "Выкуп создан и ожидает обработки",
        order_status_id: OrderStatus.find_by(name: "Новая").id
      )
      
      if order_buyout.save
        { buyout: buyout, order_buyout: order_buyout, status: :created }
      else
        { errors: order_buyout.errors, status: :unprocessable_entity }
      end
    end
end
