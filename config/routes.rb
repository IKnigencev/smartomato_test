Rails.application.routes.draw do
  default_url_options host: "localhost:3005"

  root to: redirect("/orders")

  # Обработка запросов из кабинета
  namespace :web, path: "" do
    resources :orders, only: %i[index show]
    resources :pays, only: %i[show create] do
      member do
        get "success"
        get "failure"
      end
    end

    # Страницы ошибок
    get "not_found", to: "errors#not_found", as: :not_found
    get "unknown_error", to: "errors#unknown_error", as: :unknown_error
  end

  # Обработка запросов от внешних систем
  namespace :api do
    get "pay/success", to: "pay_callback#successful"
    get "pay/failed", to: "pay_callback#failed"
  end
end
