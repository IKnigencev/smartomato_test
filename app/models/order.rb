# frozen_string_literal: true

##
# Сущность заказа
#
class Order < ApplicationRecord
  include OrderStatuses
  has_many :order_line, dependent: :destroy
  validates :status, inclusion: { in: avaliable_statuses }
  # новый, начата оплата, ошибка оплаты, оплачен
  enum :status, hash_statuses

  def human_status
    I18n.t("models.data.order.#{status}")
  end
end
