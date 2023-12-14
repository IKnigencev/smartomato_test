# frozen_string_literal: true

module Api
  ##
  # Перехват колбеков от оплаты заказа
  #
  class PayCallbackController < ApiController
    before_action :find_order

    SBER_CALLBACK_ACTION = %i[successful failed].freeze

    SBER_CALLBACK_ACTION.each do |type_callback|
      ##
      # Перехват коллбеков оплаты от сбербанка
      # успешная или не успешная оплата
      #
      define_method type_callback do
        result = ::Api::Pays::Callback.new(
          order: order, type: type_callback
        ).call
        if result.success?
          redirect_to success_redirect_page(type_callback)
        else
          redirect_to web_unknown_error_path
        end
      end
    end

    private
      def callback_params
        params.permit(:orderId)
      end

      ##
      # Поиск заказа по orderId, который сохранили при отправке на оплату
      #
      # @return [Order]
      #
      def find_order
        # https://myshop.ru/callback/?mdOrder=1234567890-098776-234-522&orderNumber=0987&operation=deposited&callbackCreationDate=Mon Jan 31 21:46:52 MSK 2022&status=0
        @order = ::Order.find_by!(
          metadata: { orderId: callback_params[:orderId] }
        )
      end

      ##
      # URL страница после оплаты
      #
      # @param [Symbol] type
      #
      # @return [String]
      #
      def success_redirect_page(type)
        if type == :successful
          success_web_pay_path(@order.id)
        else
          failure_web_pay_path(@order.id)
        end
      end
  end
end
