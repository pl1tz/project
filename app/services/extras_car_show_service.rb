class ExtrasCarShowService
    def initialize(params)
      @params = params
    end
  
    def call
      return find_car_by_id if @params[:car_id].present? 
  
      # Если id не указан, возвращаем пустой массив или сообщение об ошибке
      []
    end
    
    def self.all_extras
      return {} if ExtraName.all.empty? || Category.all.empty?
      { all_extra_names: ExtraName.all.map { |extra_name| { id: extra_name.id, name: extra_name.name } },
        all_categories: Category.all.map { |category| { id: category.id, name: category.name } } }
    end

    private
  
    def find_car_by_id
      extra_car = Extra.includes(:category, :extra_name).where(car_id: @params[:car_id])
      return {} if extra_car.empty?
  
      {
        extras: extra_car.map { |car| { extra_id: car.id, category_id: car.category.id, category_name: car.category.name, extra_name_id: car.extra_name.id, extra_name_name: car.extra_name.name } },
        all_extra_names: ExtraName.all.map { |extra_name| { id: extra_name.id, name: extra_name.name } },
        all_categories: Category.all.map { |category| { id: category.id, name: category.name } }
      }
    end

    
  end 