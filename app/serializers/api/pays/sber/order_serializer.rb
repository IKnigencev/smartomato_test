# frozen_string_literal: true

module Api
  module Pays
    ##
    # Объект для передачи в Сбербанк
    #
    class Sber::OrderSerializer
      include JSONAPI::Serializer
      set_type :sber_order

      # Имя аккаунта
      attribute :userName, proc { ::Api::Pays::Sber.user_name }

      # Пароль от аккаунта
      attribute :password, proc { ::Api::Pays::Sber.password }

      # Уникальный индификатор с нашей стороны
      attribute :orderNumber, proc { |order| order.id }

      # Сумма заказа в копейках
      # * округление вверх
      attribute :amount, proc { |order| (order.total * 100).to_f.round(half: :up) }

      # Страница после успешной оплаты
      attribute :returnUrl, proc { |order|
        ::Api::Pays::Sber.success_url(order_id: order.id)
      }

      # Страница после провальной оплаты
      attribute :failUrl, proc { |order|
        ::Api::Pays::Sber.fail_url(order_id: order.id)
      }

      # Корзина товаров в заказе
      attribute :orderBundle do |order|
        order.order_line.map do |item|
          Sber::OrderLineSerializer.new(
            item
          ).serializable_hash[:data][:attributes]
        end
      end
    end
  end
end
