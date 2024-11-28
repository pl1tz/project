class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token

  def index
    @contacts = Contact.all
    if request.format.html?
      render file: "#{Rails.root}/public/index.html", layout: false
    else
      render json: @contacts.first
    end
  end

  def show
    render json: @contact
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    if @contact.update(contact_params)
      render json: @contact, status: :ok
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    if @contact.destroy!
      head :ok
    else
      render json: @contact.errors, status: :internal_server_error
    end
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Контакт не найден." }, status: :not_found
    end

    def contact_params
      params.require(:contact).permit(:phone, :mode_operation, :auto_address)
    end
end
