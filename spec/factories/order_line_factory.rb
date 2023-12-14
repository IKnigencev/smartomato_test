# frozen_string_literal: false

FactoryBot.define do
  factory :order_line, class: "OrderLine" do
    name { Faker::Name.name }
    cost { Faker::Number.decimal(l_digits: rand(1..5), r_digits: 2) }
    count { rand(1..10) }
    total { cost * count }
  end
end
