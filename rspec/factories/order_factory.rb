# frozen_string_literal: false

FactoryBot.define do
  factory :order, class: "Order" do
    user_name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "7912" << (0..6).map { |_| (0..9).to_a.sample }.join }
    address { Faker::Address.full_address }
    total { Faker::Number.decimal(l_digits: rand(1..5), r_digits: 2) }
    metadata { { orderId: rand(5), formUrl: Faker::Internet.url } }
    status { rand(4) }
  end
end
