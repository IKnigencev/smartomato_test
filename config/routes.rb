Rails.application.routes.draw do
  root to: redirect("/orders")

  # Обработка запросов из кабинета
  namespace :web, path: "" do
    resources :orders, only: %i[index show]
  end
end
