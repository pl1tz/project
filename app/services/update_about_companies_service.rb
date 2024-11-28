class UpdateAboutCompaniesService
  def initialize(about_companies_params)
    @about_companies_params = about_companies_params
  end

  def call
    @about_companies_params.each do |company_params|
      about_company = AboutCompany.find_by(id: company_params[:id])
      if about_company
        about_company.update(description: company_params[:description])
      end
    end
  end
end 