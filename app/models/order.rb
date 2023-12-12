# frozen_string_literal: true

##
# Сущность заказа
#
class Order < ApplicationRecord
  has_many :order_line, dependent: :destroy

  # новый, начата оплата, ошибка оплаты, оплачен
  enum :status, { init: 0, start: 1, error: 2, finish: 3 }

  def human_status
    I18n.t("models.data.order.#{status}")
  end
end
