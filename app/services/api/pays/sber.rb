# frozen_string_literal: true

module Api
  module Pays
    ##
    # Модуль взаимодействия со сбером
    #
    module Sber
      module_function

      BASE_URL = "https://3dsec.sberbank.ru"
      ORDER_REGISTER = "%<base_url>s/payment/rest/register.do"

      ##
      # Базовый url для отправки запросов на сбер
      #
      # @return [String]
      #
      def base_url
        BASE_URL
      end

      ##
      # url для оплаты заказа
      #
      # @return [String]
      #
      def order_register
        format(ORDER_REGISTER, base_url: base_url)
      end

      ##
      # Имя платежного аккаунта от Сбербанка
      #
      # @return [String, NilClass]
      #
      def user_name
        ENV.fetch("SBER_USERNAME_SECRET", nil)
      end

      ##
      # Пароль от платежного аккаунта Сберабанка
      #
      # @return [String, NilClass]
      #
      def password
        ENV.fetch("SBER_PASSWORD_SECRET", nil)
      end

      ##
      # Страница где окажется
      # пользователь после успешной оплаты
      #
      # @param [Order] order_id ID заказа, который был отправлен на оплату
      #
      # @return [String]
      #
      def success_url(order_id:)
        "#{host}#{Rails.application.routes.url_helpers.api_pay_success_path}"
      end

      ##
      # Страница где окажется
      # пользователь после провального сценария оплаты
      #
      # @param [Order] order_id ID заказа, который был отправлен на оплату
      #
      # @return [String]
      #
      def fail_url(order_id:)
        "#{host}#{Rails.application.routes.url_helpers.api_pay_failed_path}"
      end

      def host
        Rails.application.routes.url_helpers.root_url
      end
    end
  end
end
