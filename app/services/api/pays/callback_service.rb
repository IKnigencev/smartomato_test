# frozen_string_literal: true

module Api
  ##
  # Создание случайного заказа
  #
  class Pays::CallbackService
    extend Dry::Initializer
    # Заказ
    option :order
    # Тип колбека успешная или провальная оплата
    option :type

    def call
      order.update!(status: status_order)
      Success.new(:ok)
    rescue Exception => e
      DevelopmentMailer.unknown_error(e)
      Failure.new(:unknown_error)
    end

    private
      ##
      # Возвращает верный статус для обновления заказа
      #
      # @return [Symbol]
      #
      def status_order
        finish_pay? ? :finish : :error
      end

      def finish_pay?
        type == :successful
      end
  end
end
