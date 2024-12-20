class CarCatalogContentsController < ApplicationController
  before_action :set_car_catalog_content, only: %i[ show edit update destroy ]

  # GET /car_catalog_contents or /car_catalog_contents.json
  def index
    @car_catalog_contents = CarCatalogContent.all
  end

  # GET /car_catalog_contents/1 or /car_catalog_contents/1.json
  def show
  end

  # GET /car_catalog_contents/new
  def new
    @car_catalog_content = CarCatalogContent.new
  end

  # GET /car_catalog_contents/1/edit
  def edit
  end

  # POST /car_catalog_contents or /car_catalog_contents.json
  def create
    @car_catalog_content = CarCatalogContent.new(car_catalog_content_params)

    respond_to do |format|
      if @car_catalog_content.save
        format.html { redirect_to @car_catalog_content, notice: "Car catalog content was successfully created." }
        format.json { render :show, status: :created, location: @car_catalog_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car_catalog_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /car_catalog_contents/1 or /car_catalog_contents/1.json
  def update
    respond_to do |format|
      if @car_catalog_content.update(car_catalog_content_params)
        format.html { redirect_to @car_catalog_content, notice: "Car catalog content was successfully updated." }
        format.json { render :show, status: :ok, location: @car_catalog_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car_catalog_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_catalog_contents/1 or /car_catalog_contents/1.json
  def destroy
    @car_catalog_content.destroy!

    respond_to do |format|
      format.html { redirect_to car_catalog_contents_path, status: :see_other, notice: "Car catalog content was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_catalog_content
      @car_catalog_content = CarCatalogContent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def car_catalog_content_params
      params.require(:car_catalog_content).permit(:car_catalog_id, :content)
    end
end
