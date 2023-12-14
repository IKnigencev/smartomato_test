# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::Pays::SberOrderCallbackOperation do
  let(:order) { FactoryBot.create(:order) }

  context "колбек об успехе" do
    before do
      @params = { orderNumber: order.id, operation: "", callbackCreationDate: Time.current, status: 1 }
      @service = described_class.new(
        order: order, type: :successful, params: @params
      )
      @service.call
    end

    it "вернет верный ответ" do
      expect(@result).to be_success
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq(:finish)
    end

    it "добавит поля для метаданных платежа" do
      expect(order.reload.metadata.slice("orderNumber", "operation", "callbackCreationDate", "status").symbolize_names).to eq(@params)
    end
  end

  context "колбек о провальной оплате" do
    before do
      @params = { orderNumber: order.id, operation: "", callbackCreationDate: Time.current, status: 0 }
      @service = described_class.new(
        order: order, type: :successful, params: @params
      )
      @result = @service.call
    end

    it "вернет верный ответ" do
      expect(@result).to be_success
    end

    it "обновит статус заказа" do
      expect(order.reload.status).to eq(:error)
    end

    it "добавит поля для метаданных платежа" do
      expect(order.reload.metadata.slice("orderNumber", "operation", "callbackCreationDate", "status").symbolize_names).to eq(@params)
    end
  end

  context "при случайно ошибке" do
    before do
      @order_before = order.dup
      @service = described_class.new(
        order: order, type: :successful, params: {}
      )
      allow(@service).to receive(:update_order!).and_raise(StandardError)
      @result = @service.call
    end

    it "вернет верный ответ" do
      expect(@result).to be_failure
    end

    it "не изменит данные заказа" do
      expect(@order_before).to eq(order.reload.dup)
    end

    it "отправит письмо об ошибке" do
      expect(DevelopmentMailer).to have_received(:unknown_error)
    end
  end
end
