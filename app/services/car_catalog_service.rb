class CarCatalogService
    def self.all_catalog
        CarCatalog.all.group_by { |car| car.brand }.sort.to_h.map do |brand, cars|
            {
              brand: brand,
              models: cars.map { |car| { id: car.id, model: car.model } }.uniq.sort_by { |car| car[:model] }
            }
        end
    end
  end