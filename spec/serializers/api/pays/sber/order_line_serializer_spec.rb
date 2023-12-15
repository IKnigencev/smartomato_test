# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::Pays::Sber::OrderLineSerializer do
  let(:order_line) { create(:order_line) }

  it "создаст верные ключи" do
    expect(result_serialize[:data][:attributes].keys).to eq(
      %i[positionId name itemAmount itemCode itemPrice quantity tax]
    )
  end

  it "itemPrice в копейках" do
    expect(result_serialize[:data][:attributes][:itemPrice])
      .to eq((order_line.cost * 100).to_i)
  end

  it "itemAmount в копейках и два знака после запятой" do
    expect(result_serialize[:data][:attributes][:itemAmount])
      .to eq(format("%.2f", order_line.total))
  end

  it "верное поле налога" do
    expect(result_serialize[:data][:attributes][:tax]).to eq(
      [
        {
          taxType: 0,
          taxSum: 0
        }
      ]
    )
  end

  it "верное поле quantity" do
    expect(result_serialize[:data][:attributes][:quantity]).to eq(
      [
        {
          value: order_line.count,
          measure: "шт"
        }
      ]
    )
  end

  def result_serialize
    described_class.new(order_line).serializable_hash
  end
end
