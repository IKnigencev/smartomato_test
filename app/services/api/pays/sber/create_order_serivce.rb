# frozen_string_literal: true

module Api
  module Pays
    ##
    # Отправка корзины в сбер
    #
    class Sber::CreateOrderSerivce
      extend Dry::Initializer
      include Dry::Monads[:result]
      include Client::Connection
      # Заказ
      option :params

      ##
      # Отправка
      #
      # @return [Success, Failure]
      #
      def call
        body = super
        return Failure.new(key: :empty_body) if body.blank?

        validate_body(body)
      rescue ::Client::Errors::Invalid
        Failure.new(key: :something_went_wrong)
      end

      private
        def send_request
          conn.get
        end

        def webhook_url
          Sber.order_register
        end

        def payload_params
          params
        end

        def verify_ssl
          false
        end

        ##
        # Проверка результата запроса
        #
        # @param [Hash<Symbol>] data
        #
        # @return [Success, Failure]
        #
        def validate_body(data)
          return failure_response(data) unless valid_response?(data)

          Success.new(data)
        end

        ##
        # Проверка валидности отправки
        # * errorCode должкн быть 0
        #
        # @param [Hash<Symbol>] body
        #
        # @return [Boolean]
        #
        def valid_response?(body)
          body.present? && body.is_a?(Hash) &&
            body[:errorCode].to_i.present? && body[:orderId].present? && body[:formUrl].present?
        end

        def failure_response(body)
          # Отправляем пиисьмо для просмотра что не так
          DevelopmentMailer.some_errors(body).deliver_later
          Failure.new(
            key: :error_code, data: body[:errorCode]
          )
        end
    end
  end
end
