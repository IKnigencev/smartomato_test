# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::Pays::SberOrderCallbackOperation do
  let(:order) { create(:order) }

  before do
    allow(DevelopmentMailer).to receive(:unknown_error).and_return(
      instance_double(
        ActionMailer::MessageDelivery,
        deliver_later: true
      )
    )
  end

  context "колбек об успехе" do
    before do
      @params = stub_success_callback
      @service = described_class.new(
        order: order, type: :successful, params: @params
      )
      @result = @service.call
    end

    it "вернет положительный ответ" do
      expect(@result).to be_success
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq("finish")
    end

    it "добавит поля для метаданных платежа" do
      expect(order.reload.metadata.keys.sort).to eq(
        %w[
          orderNumber operation callbackCreationDate status
          formUrl orderId
        ].sort
      )
    end

    it "сохранит верные данные колбека" do
      result_data = order.reload.metadata.slice(
        "orderNumber", "operation", "status"
      ).symbolize_keys
      expect(result_data).to eq(@params.except(:callbackCreationDate))
    end
  end

  context "колбек о провальной оплате" do
    before do
      @params = stub_failure_callback
      @service = described_class.new(
        order: order, type: :failed, params: @params
      )
      @result = @service.call
    end

    it "вернет положительный ответ" do
      expect(@result).to be_success
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq("error")
    end

    it "добавит поля для метаданных платежа" do
      expect(order.reload.metadata.keys.sort).to eq(
        %w[
          orderNumber operation callbackCreationDate status
          formUrl orderId
        ].sort
      )
    end

    it "сохранит верные данные колбека" do
      result_data = order.reload.metadata.slice(
        "orderNumber", "operation", "status"
      ).symbolize_keys
      expect(result_data).to eq(@params.except(:callbackCreationDate))
    end
  end

  context "тип колбека успешный, но данные статус неверный" do
    before do
      @result = described_class.new(
        order: order, type: :successful, params: stub_failure_callback
      ).call
    end

    it "вернет положительный ответ" do
      expect(@result).to be_success
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq("error")
    end
  end

  context "тип колбека отрицательный, но данные статус успешный" do
    before do
      @result = described_class.new(
        order: order, type: :failed, params: stub_success_callback
      ).call
    end

    it "вернет положительный ответ" do
      expect(@result).to be_success
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq("error")
    end
  end

  context "при случайно ошибке" do
    before do
      @service = described_class.new(
        order: order, type: :successful, params: {}
      )
      allow(@service).to receive(:update_order!).and_raise(StandardError)
      @before_status = order.status
      @before_metadata = order.metadata
      @result = @service.call
    end

    it "вернет отрицательный ответ" do
      expect(@result).to be_failure
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

  def stub_success_callback
    { orderNumber: order.id, operation: "", callbackCreationDate: Time.current, status: 1 }
  end

  def stub_failure_callback
    { orderNumber: order.id, operation: "", callbackCreationDate: Time.current, status: 0 }
  end
end
