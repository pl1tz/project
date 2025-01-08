class InstallmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_installment, only: %i[ show update destroy ]

  def index
    @installments = Installment.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @installments
    end
  end

  def show  
    render json: @installment
  end

  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @installment = Installment.new(installment_params)

    ActiveRecord::Base.transaction do
      if @installment.save
        crm_service = PlexCrmService.new
        crm_response = crm_service.send_installment_application(@installment)
        
        Rails.logger.info "CRM Response: #{crm_response.inspect}"
        
        unless crm_response[:success]
          error_message = "Failed to send to CRM: #{crm_response[:message]}"
          Rails.logger.error error_message
          raise ActiveRecord::Rollback, error_message
        end

        Rails.logger.info "Successfully created installment application and sent to CRM"
        create_order_installment(@installment)
      else
        Rails.logger.error "Failed to save installment: #{@installment.errors.full_messages}"
        render json: @installment.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback => e
    render json: { error: e.message || "Failed to create installment application" }, 
           status: :unprocessable_entity
  end

  def update
    if @installment.update(installment_params)
      render json: @installment, status: :ok
    else
      render json: @installment.errors, status: :unprocessable_entity
    end     
  end

  def destroy
    if @installment.destroy
      head :ok
    else
      render json: @installment.errors, status: :unprocessable_entity
    end
  end

  private
    def set_installment
      @installment = Installment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Рассрочка не найдена" }, status: :not_found
    end

    def installment_params
      params.require(:installment).permit(:car_id, :name, :phone, :credit_term, :initial_contribution)
    end

    def create_order_installment(installment)
      order_installment = OrdersInstallment.new(
        installment_id: installment.id,
        description: "Рассрочка создана и ожидает обработки",
        order_status_id: OrderStatus.find_by(name: "Новая").id
      )
      if order_installment.save
        render json: { installment: installment, order_installment: order_installment }, status: :created
      else
        render json: { installment: installment, errors: order_installment.errors }, status: :unprocessable_entity
      end
    end
end
