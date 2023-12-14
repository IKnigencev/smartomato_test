# frozen_string_literal: true

module Api
  ##
  # Передача заказа в Сбербанк
  #
  class Pays::SberOrderCallbackOperation
    extend Dry::Initializer
    include Dry::Monads[:result]
    # Заказ
    option :order
    # Тип колбека успешная или провальная оплата
    option :type
    # Параметры
    option :params

    ##
    # Отправка корзины
    #
    # @return [Success, Failure]
    #
    def call
      errors_cath do
        update_order!
        Success.new(:ok)
      end
    end

    ##
    # Определяем, что оплата прошла успешно
    #
    # @return [Boolean]
    #
    def finish_pay?
      type == :successful && params[:status].to_i == 1
    end

    private
      def update_order!
        order.status = status_order
        order.metadata = order.metadata.merge(*params.slice(:orderNumber, :operation, :callbackCreationDate, :status))
        order.save!
      end

      ##
      # Возвращает верный статус для обновления заказа
      #
      # @return [Symbol]
      #
      def status_order
        finish_pay? ? :finish : :error
      end

      def errors_cath(&block)
        block.call
      rescue Exception => e
        puts e.inspect
        puts e.backtrace
        DevelopmentMailer.unknown_error(e).deliver_later
        Failure.new(key: :unknown_error)
      end
  end
end
