# frozen_string_literal: true

module Web
  ##
  # Контроллер оплаты заказа
  #
  class PaysController < WebController
    before_action :find_order
    CALLBACK_ACTIONS = %i[success failure].freeze

    ##
    # ТЕСТОВАЯ страница для мока страницы от сбера
    # Выбор сценария колбека положительного или отрицательного
    #
    def show
      @params_for_redirect = stub_test_callback_sber_params
      @success_url = ::Api::Pays::Sber.success_url(order_id: @order.id)
      @failure_url = ::Api::Pays::Sber.fail_url(order_id: @order.id)
    end

    ##
    # Оплата заказа
    #
    def create
      result = ::Web::Pays::PayThroughSberOperation.new(order: @order).call
      if result.success?
        redirect_to result.value![:redirect_url], allow_other_host: true
      else
        redirect_to web_unknown_error_path
      end
    end

    CALLBACK_ACTIONS.each do |method_name|
      ##
      # Страницы после успешной или провальной оплаты заказа
      #
      define_method method_name do
        flash_message(method_name == :success)
        render "web/orders/show"
      end
    end

    private
      def create_params
        params.permit(:id)
      end

      ##
      # Поиск заказа по ID из параметров
      #
      # @return [Order]
      #
      def find_order
        puts "create_params #{create_params.inspect}"
        @order = ::Order.find(create_params[:id])
      end

      def flash_message(finish_pay)
        if finish_pay
          flash.now[:notice] = text_for_alert(finish_pay)
        else
          flash.now[:alert] = text_for_alert(finish_pay)
        end
      end

      def text_for_alert(finish_pay)
        finish_pay ? I18n.t("success.pay.finish") : I18n.t("errors.pay.error")
      end

      ##
      # Стаб параметров в коллбеке от сбера
      #
      def stub_test_callback_sber_params
        {
          success: {
            mdOrder: 132,
            orderNumber: @order.id,
            operation: "deposited",
            callbackCreationDate: Time.current,
            status: 1
          },
          failure: {
            mdOrder: 132,
            orderNumber: @order.id,
            operation: "deposited",
            callbackCreationDate: Time.current,
            status: 0
          }
        }
      end
  end
end
