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

  def create
    Rails.logger.info "Received params: #{params.inspect}"
    @credit = Credit.new(credit_params)

    if @credit.save 
      create_order_credit(@credit)
    else
      render json: @credit.errors, status: :unprocessable_entity
    end
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
