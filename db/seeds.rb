require "factory_bot_rails"

Dir[Rails.root.join("rspec", "factories", "**", "*.rb")].each { |f| require f }

##
# Стаб заказов
#
def create_orders
  @orders = FactoryBot.create_list(:order, 10)
end

##
# Стаб товаров
#
def create_order_lines
  @orders.each do |order|
    FactoryBot.create_list(:order_line, 5, order: order)
  end
end

if Rails.env.development?
  create_orders
  create_order_lines
end
