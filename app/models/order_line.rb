# frozen_string_literal: true

##
# Сущность строк заказа
# хранит информацию о товаре
#
class OrderLine < ApplicationRecord
  belongs_to :order, optional: true
  validates :name, :cost, :count, :total, presence: true
  validate :total_sum_check

  private
    def total_sum_check
      return if cost.present? && count.present? && total.eql?(cost * count)

      errors.add(:total, I18n.t("errors.order_line.total"))
    end
end
