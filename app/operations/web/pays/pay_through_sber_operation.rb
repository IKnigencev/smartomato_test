# frozen_string_literal: true

module Web
  ##
  # Передача заказа в Сбербанк
  #
  class Pays::PayThroughSberOperation
    extend Dry::Initializer
    include Dry::Monads[:result]
    # Заказ
    option :order

    ##
    # Отправка корзины
    #
    # @return [Success, Failure]
    #
    def call
      errors_cath do
        result = request_to_sber
        return Failure.new(key: :request_error) unless result.success?

        update_order!(result)
        Success.new(redirect_url: result.value![:formUrl])
      end
    end

    private
      def update_order!(result)
        order.status = :start if order.status != "start"
        order.metadata = result.value!
        order.save!
      end

      ##
      # Отправка запроса в Сбербанк на оплату
      #
      # @return [Success, Failure]
      #
      def request_to_sber
        return Success.new(
          orderId: 123,
          formUrl: Rails.application.routes.url_helpers.web_pay_path(order.id)
        ) if Rails.env.development?

        ::Api::Pays::Sber::CreateOrderService.new(params: params_request).call
      end

      ##
      # Сериализатор для представления данных
      #
      # @return [Hash<Symbol>] Данные в нужном формате для оплаты
      #
      def params_request
        ::Api::Pays::Sber::OrderSerializer.new(
          order
        ).serializable_hash[:data][:attributes]
      end

      def errors_cath(&block)
        block.call
      rescue Exception => e
        DevelopmentMailer.unknown_error(e).deliver_later
        Failure.new(key: :unknown_error)
      end
  end
end
