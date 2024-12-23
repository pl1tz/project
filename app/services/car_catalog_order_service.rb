class CarCatalogOrderService
    def self.all_orders_with_car_details
      CarCatalogOrder.includes(:order_status).map do |order|
        car_catalog = CarCatalog.find_by(id: order.car_catalog)
        {
          order_id: order.id,
          order_status: {
            id: order.order_status.id,
            name: order.order_status.name
          },
          car_catalog: car_catalog ? {
            id: car_catalog.id,
            brand: car_catalog.brand,
            model: car_catalog.model,
            power: car_catalog.power,
            acceleration: car_catalog.acceleration,
            consumption: car_catalog.consumption,
            max_speed: car_catalog.max_speed
          } : nil,
          customer_name: order.name,
          customer_phone: order.phone
        }
      end
    end
    def self.order_with_car_details(id)
        order = CarCatalogOrder.includes(:order_status).find_by(id: id)
        return nil unless order
      
        car_catalog = CarCatalog.find_by(id: order.car_catalog)
        {
          order_id: order.id,
          order_status: {
            id: order.order_status.id,
            name: order.order_status.name
          },
          car_catalog: car_catalog ? {
            id: car_catalog.id,
            brand: car_catalog.brand,
            model: car_catalog.model,
            power: car_catalog.power,
            acceleration: car_catalog.acceleration,
            consumption: car_catalog.consumption,
            max_speed: car_catalog.max_speed
          } : nil,
          customer_name: order.name,
          customer_phone: order.phone
        }
    end
  end