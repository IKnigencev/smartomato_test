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
      @orders = ::Order.all.order(created_at: :desc)
    end

    ##
    # Просмотр странички заказа
    #
    def show
      @order = ::Order.preload(:order_line).find(order_param[:id])
    end

    private
      def order_param
        params.permit(:id)
      end
  end
end
