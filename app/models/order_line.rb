# frozen_string_literal: true

##
# Сущность строк заказа
# хранит информацию о товаре
#
class OrderLine < ApplicationRecord
  belongs_to :order
end
