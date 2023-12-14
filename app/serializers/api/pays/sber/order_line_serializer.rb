# frozen_string_literal: true

module Api
  module Pays
    ##
    # Объект для передачи в Сбербанк
    #
    class Sber::OrderLineSerializer
      include JSONAPI::Serializer
      set_type :sber_order_line

      # Уникальный индификатор товарной позиции с нашей стороны
      attribute :positionId, proc { |item| item.id }

      # Название товара
      attribute :name, proc { |item| item.name }

      # Сумма стоимости всех товарных позиций одного positionId
      attribute :itemAmount, proc { |item| format("%.2f", item.total) }

      # Номер (идентификатор) товарной позиции в системе магазина
      attribute :itemCode, proc { |item| item.id }

      # Стоимость одной товарной позиции
      # позиция в минимальных единицах валюты (копейки)
      attribute :itemPrice, proc { |item| (item.cost * 100).to_i }

      # Описание общего количества товарных
      # позиций одного positionId и их мера измерения
      attribute :quantity do |item|
        [
          {
            value: item.count,
            measure: "шт"
          }
        ]
      end

      # Описание налога
      attribute :tax do
        [
          {
            taxType: 0,
            taxSum: 0
          }
        ]
      end
    end
  end
end
