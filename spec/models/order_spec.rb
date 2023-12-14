# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order do
  context "Валидация" do
    context "Создаст запись" do
      it "Все поля заполнены" do
        rec = described_class.new(
          user_name: "name", phone: "phone", email: "email", address: "address", total: 0
        )
        expect { rec.save }.to change(described_class, :count)
      end
    end

    context "Не создаст запись" do
      %w[
        user_name phone email address total
      ].each do |field|
        it "Пустое поле #{field}" do
          rec = described_class.new(
            user_name: "name", phone: "phone", email: "email", address: "address", total: 0
          )
          rec.send("#{field}=", nil)
          expect { rec.save }.not_to change(described_class, :count)
        end
      end

      it "указана неверный статус" do
        expect do
          rec = described_class.new(
            user_name: "name", phone: "phone", email: "email", address: "address", total: 0,
            status: "some_status"
          )
          rec.save
        end.to raise_error(ArgumentError)
      end
    end
  end
end
