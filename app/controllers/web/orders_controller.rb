# frozen_string_literal: true

module Web
  ##
  # Действия с заказами
  #
  class OrdersController < WebController
    # before_action :authenticate_user!

    ##
    # Страница со списоком задач
    #
    def index
      @orders = Order.all.order(created_at: :desc)
    end

    ##
    # Просмотр странички заказа
    #
    def show
      @order = Order.preload(:order_line).find(params.require(:id))
    end
  end
end
