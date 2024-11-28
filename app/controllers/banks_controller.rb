class BanksController < ApplicationController
  before_action :set_bank, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @banks = Bank.includes(:programs).all 
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @banks.as_json(include: :programs)
    end
  end

  def show
    render json: @bank.as_json(include: :programs)
  end

  def create
    @bank = Bank.new(bank_params)
    if @bank.save 
      render json: @bank, status: :created
    else
      render json: @bank.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /banks/1 or /banks/1.json
  def update
    if @bank.update(bank_params)
      render json: @bank, status: :ok
    else
      render json: @bank.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if Program.exists?(bank_id: params[:id])
      render json: { error: 'Банк не может быть удален, так как используется в таблице программ' }, status: :unprocessable_entity
    else
      if @bank.destroy
        head :ok
      else
        render json: @bank.errors, status: :unprocessable_entity
      end
    end
  end

  private
    def set_bank
      @bank = Bank.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Банк не найден' }, status: :not_found
    end

    def bank_params
      params.require(:bank).permit(:name, :country)
    end
end
