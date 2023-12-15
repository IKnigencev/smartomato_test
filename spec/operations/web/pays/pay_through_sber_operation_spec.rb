# frozen_string_literal: true

require "rails_helper"

RSpec.describe Web::Pays::PayThroughSberOperation do
  let(:order) { create(:order) }

  before do
    allow(DevelopmentMailer).to receive(:unknown_error).and_return(
      instance_double(
        ActionMailer::MessageDelivery,
        deliver_later: true
      )
    )
  end

  context "успешный сценарий" do
    before do
      @response = { errorCode: 0, orderId: "order-id", formUrl: "url" }
      stub_request(
        :get, Api::Pays::Sber.order_register
      ).with(query: hash_including({})).to_return(status: 200, body: @response.to_json)
      @result = described_class.new(order: order).call
    end

    it "вернет положительный ответ" do
      expect(@result).to be_success
    end

    it "вернет верные данные" do
      expect(@result.value!).to eq({ redirect_url: @response[:formUrl] })
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq("start")
    end

    it "обновит метаданные заказа" do
      expect(order.reload.metadata.symbolize_keys).to eq(@response)
    end
  end

  context "ошибка при запросе к сберу" do
    before do
      stub_request(
        :get, Api::Pays::Sber.order_register
      ).with(query: hash_including({})).to_return(status: 302, body: {}.to_json)
      @before_status = order.status
      @before_metadata = order.metadata
      @result = described_class.new(order: order).call
    end

    it "вернет отрицательный ответ" do
      expect(@result).to be_failure
    end

    it "вернет верные данные" do
      expect(@result.failure).to eq({ key: :request_error })
    end

    it "не обновит статус заказа" do
      expect(order.reload.status).to eq(@before_status)
    end

    it "не обновит метаданные заказа" do
      expect(order.reload.metadata).to eq(@before_metadata)
    end
  end

  context "при случайной ошибке" do
    before do
      service = described_class.new(order: order)
      allow(service).to receive(:request_to_sber).and_raise(StandardError)
      @before_status = order.status
      @before_metadata = order.metadata
      @result = service.call
    end

    it "вернет отрицательный ответ" do
      expect(@result).to be_failure
    end

    it "вернет верные данные" do
      expect(@result.failure).to eq({ key: :unknown_error })
    end

    it "не обновит статус заказа" do
      expect(order.reload.status).to eq(@before_status)
    end

    it "не обновит метаданные заказа" do
      expect(order.reload.metadata).to eq(@before_metadata)
    end

    it "отправит письмо об ошибке" do
      expect(DevelopmentMailer).to have_received(:unknown_error)
    end
  end
end
