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
        @type_callback = type_callback
        if callback_service.call.success?
          redirect_to success_redirect_page
        else
          redirect_to web_unknown_error_path
        end
      end
    end

    private
      def callback_params
        params.permit(:mdOrder, :orderNumber, :operation, :callbackCreationDate, :status)
      end

      ##
      # Поиск заказа по orderNumber, который сохранили при отправке на оплату
      #
      # @return [Order]
      #
      def find_order
        @order = ::Order.started_pay.find(callback_params[:orderNumber])
      end

      def callback_service
        @callback_service ||= ::Api::Pays::SberOrderCallbackOperation.new(
          order: @order, type: @type_callback, params: callback_params
        )
      end

      ##
      # URL страница после оплаты
      #
      # @return [String]
      #
      def success_redirect_page
        if callback_service.finish_pay?
          success_web_pay_path(@order.id)
        else
          failure_web_pay_path(@order.id)
        end
      end
  end
end
