# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderLine do
  context "Валидация" do
    context "Создаст запись" do
      it "Все поля заполнены" do
        cost = rand(10..100)
        count = rand(10..100)
        rec = described_class.new(
          name: "name", cost: cost, count: count, total: cost * count
        )
        expect { rec.save }.to change(described_class, :count)
      end
    end

    context "Не создаст запись" do
      %w[
        name cost count total
      ].each do |field|
        it "Пустое поле #{field}" do
          cost = rand(10..100)
          count = rand(10..100)
          rec = described_class.new(
            name: "name", cost: cost, count: count, total: cost * count
          )
          rec.send("#{field}=", nil)
          expect { rec.save }.not_to change(described_class, :count)
        end
      end

      it "указана невалидная итоговая сумма" do
        rec = described_class.new(
          name: "name", cost: rand(10..100), count: rand(10..100), total: 1
        )
        expect { rec.save }.not_to change(described_class, :count)
      end
    end
  end
end
