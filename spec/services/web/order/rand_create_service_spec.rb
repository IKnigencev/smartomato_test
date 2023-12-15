# frozen_string_literal: true

require "rails_helper"

RSpec.describe Web::Order::RandCreateService do
  it "создаст верное количество заказов" do
    @before_count = Order.count
    10.times { described_class.call }
    expect(Order.count - @before_count).to eq(10)
  end

  it "сгенерирует уникальные заказы" do
    created_orders = []
    10.times { created_orders << described_class.call }
    fields = {
      user_name: created_orders.map(&:user_name).uniq,
      phone: created_orders.map(&:phone).uniq,
      email: created_orders.map(&:email).uniq,
      address: created_orders.map(&:address).uniq
    }
    expect(fields.values.sum(&:count)).to eq(40)
  end
end
