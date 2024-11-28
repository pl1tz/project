class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @programs = Program.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @programs
    end
  end

  def show
    render json: @program
  end

  def create
    @program = Program.new(program_params)
    if @program.save
      render json: @program, status: :created
    else
      render json: @program.errors, status: :unprocessable_entity
    end
  end

  def update
    if @program.update(program_params)
      render json: @program, status: :ok
    else
      render json: @program.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @program.destroy
      head :ok
    else
      render json: @program.errors, status: :unprocessable_entity
    end
  end

  private
    def set_program
      @program = Program.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Программа не найдена' }, status: :not_found
    end

    def program_params
      params.require(:program).permit(:bank_id, :program_name, :interest_rate)
    end
end
