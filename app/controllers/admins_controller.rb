class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /admins/login
  def login
    admin = Admin.find_by(email: params[:email])

    if admin && params[:password] == admin.password
      head :ok
    else
      head :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:email, :password)
    end
end
