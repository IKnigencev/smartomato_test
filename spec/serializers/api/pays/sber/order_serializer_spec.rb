# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::Pays::Sber::OrderSerializer do
  let(:order) { create(:order) }

  it "создаст верные ключи" do
    expect(result_serialize[:data][:attributes].keys).to eq(
      %i[userName password orderNumber amount returnUrl failUrl orderBundle]
    )
  end

  it "верный формат списка товароа" do
    expect(result_serialize[:data][:attributes][:orderBundle]).to be_is_a(Array)
  end

  it "при пустом списке товаров" do
    order.order_line.destroy_all
    expect { result_serialize[:data][:attributes] }.to raise_error(described_class::EmptyOrderLine)
  end

  context "верно посчитает amount" do
    it "вернет в копейках" do
      expect(result_serialize[:data][:attributes][:amount]).to eq((order.total * 100).to_f)
    end

    it "округлит вверх" do
      order.update!(total: 3.55555)
      expect(result_serialize[:data][:attributes][:amount]).to eq(356)
    end
  end

  def result_serialize
    described_class.new(order).serializable_hash
  end
end
