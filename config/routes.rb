Rails.application.routes.draw do
  resources :car_catalog_orders
  resources :car_catalog_extras
  resources :car_catalog_extra_names
  resources :car_catalog_extra_groups
  resources :car_catalog_configurations
  resources :car_catalog_images
  resources :car_catalog_engines
  resources :car_catalog_texnos
  resources :car_catalog_contents
  resources :car_colors
  resources :car_catalogs do
    collection do
      get 'all_catalog'
      get 'cars_by_brand'
    end
    member do
      get 'compare'
    end
  end
  resources :banners do 
    collection do 
    get :banner_all
    end 
  end 
  resources :engine_capacity_types
  resources :engine_power_types
  resources :engine_name_types
  resources :orders_call_requests
  resources :orders_buyouts
  resources :orders_exchanges
  resources :orders_installments
  resources :orders_credits
  resources :contacts
  resources :about_companies do
    collection do
      patch :update_multiple 
    end
  end
  resources :order_statuses
  resources :admins, only: [:login]
  resources :extra_names
  resources :extras do
    collection do
      get :car_show
      get :all_extras
      post :update_multiple
      patch :update_multiple 
    end
  end
  resources :categories
  resources :images do
    collection do
      post :update_multiple
      patch :update_multiple 
    end
  end
  resources :drive_types
  resources :gearbox_types
  resources :engine_types
  resources :body_types
  resources :colors
  resources :brands
  resources :generations
  resources :models
  resources :history_cars
  resources :call_requests
  resources :cars do
    collection do
      get :total_pages
    end
  end
  resources :banks
  resources :programs
  resources :installments
  resources :exchanges
  resources :buyouts
  resources :credits
  resources :trade_in_offers
  resources :installment_plans
  resources :credit_offers
  resources :offers
  resources :call_requests
  resources :admin, only: [:index]
  resources :reports, only: [:show]
  #Маршруты для клиентов
  post 'verify_captcha', to: 'captcha#verify'

  get 'cars' => 'cars#index'#Список автомобилей
  get 'last_cars' => 'cars#last_cars'#Последние 20 автомобилей
  get 'cars_count' => 'cars#cars_count'#Количество автомобилей
  get 'car_details' => 'cars#car_details'#Детали автомобиля
  get 'cars/:id' => 'cars#show'#Показать автомобиль
  get 'filters', to: 'cars#filters'#Фильтры для автомобилей
  get 'car_ids', to: 'cars#car_ids'#Список идентификаторов автомобилей
  get 'exchange' => 'exchanges#index'#Обмен


  post 'exchange' => 'exchanges#create'#Создать обмен
  
  get 'installment' => 'installments#index'#Рассрочка
  post 'installment' => 'installments#create'#Создать рассрочку
  
  get 'buyout' => 'buyouts#index'#Выкуп
  post 'buyout' => 'buyouts#create'#Создать выкуп

  get 'credit' => 'credits#top_programs'#Топ программ
  get 'credits' => 'credits#index '#Список программ
  post 'credit' => 'credits#create'#Создать программу
  get 'credit/:id' => 'credits#show'#Показать программу
  get 'about' => 'about_companies#index'#О компании
  get 'car/:brand/:id' => 'cars#show'#Показать автомобиль

  get 'favorites', to: 'favorites#index'#Избранное
  #post 'admins/login' => 'admins#login'#Авторизация
  get 'admin' => 'admin#index'#Главная страница

  get 'admin/cars' => 'cars#index'#Автомобили
  get 'admin/car/:id' => 'cars#show'#Показать автомобиль
  get 'admin/car/:id/history' => 'cars#show'#История автомобиля
  get 'admin/car/:id/complectation' => 'cars#show'#Комплектация автомобиля
  get 'admin/car/:id/images' => 'cars#show'#Изображения автомобиля
  get 'admin/add_car' => 'cars#add_car'#Добавить автомобиль
  get 'admin/categories' => 'cars#add_car'#Категории
  get 'admin/banks' => 'banks#index'#Банки
  get 'admin/programs' => 'programs#index'#Программы
  get 'admin/orders' => 'cars#add_car'#Заказы
  get 'admin/contacts' => 'contacts#index'#Контакты
  get 'admin/about' => 'about_companies#index'#О компании
  get 'admin/banners' => 'cars#add_car'#Добавить автомобиль
  get 'privacy' => 'cars#add_car'#Политика конфиденциальности
  


  match "/404", to: "errors#not_found", via: :all
  match "*unmatched", to: "errors#not_found", via: :all

  # Обработка всех остальных маршрутов
  match '*path', to: 'application#frontend', via: :all
  
end
  