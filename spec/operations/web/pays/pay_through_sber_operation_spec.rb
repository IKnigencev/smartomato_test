# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "отрицательный сценарий" do
  it "вернет верный ответ" do
    expect(subject).to be_failure
  end

  it "не изменит данные заказа" do
    expect { subject }.not_to change(order, :status)
  end
end

RSpec.describe Web::Pays::PayThroughSberOperation do
  let(:order) { FactoryBot.create(:order) }

  context "успешный сценарий" do
  end

  context "ошибка при запросе к сберу" do
    subject do
      stub_request(
        :get, Api::Pays::Sber.order_register
      ).with(query: hash_including({})).to_return(status: 400)
      described_class.new(order: order).call
    end

    include_examples "отрицательный сценарий"
  end

  context "при случайно ошибке" do
    subject do
      service = described_class.new(order: order)
      allow(service).to receive(:request_to_sber).and_raise(StandardError)
      service.call
    end

    include_examples "отрицательный сценарий"
  end
end
