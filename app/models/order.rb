# frozen_string_literal: true

##
# Сущность заказа
#
class Order < ApplicationRecord
  include OrderStatuses
  has_many :order_line, dependent: :destroy
  validates :user_name, :phone, :email, :address, :total, presence: true
  # новый, начата оплата, ошибка оплаты, оплачен
  enum :status, hash_statuses

  def human_status
    I18n.t("models.data.order.#{status}")
  end
end
