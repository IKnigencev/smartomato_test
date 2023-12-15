# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::Pays::Sber::CreateOrderService do
  before do
    allow(DevelopmentMailer).to receive(:some_errors).and_return(
      instance_double(
        ActionMailer::MessageDelivery,
        deliver_later: true
      )
    )
  end

  context "успешный ответ от сбербанка" do
    before do
      @response = { errorCode: 0, orderId: "order-id", formUrl: "url" }
      stub_request(
        :get, Api::Pays::Sber.order_register
      ).to_return(status: 200, body: @response.to_json)
      @result = described_class.new(params: {}).call
    end

    it "вернет положительный результат" do
      expect(@result).to be_success
    end

    it "вернет верные данные" do
      expect(@result.value!).to eq(@response)
    end
  end

  %i[errorCode orderId formUrl].each do |field|
    context "отсутствуют параметр: #{field}" do
      before do
        @response = { errorCode: 0, orderId: "order-id", formUrl: "url" }
        @response.delete(field)
        stub_request(
          :get, Api::Pays::Sber.order_register
        ).to_return(status: 200, body: @response.to_json)
        @result = described_class.new(params: {}).call
      end

      it "вернет отрицательный результат" do
        expect(@result).to be_failure
      end

      it "вернет верные данные" do
        expect(@result.failure).to eq({ key: :error_code, data: @response })
      end

      it "отправит письмо об ошибке" do
        expect(DevelopmentMailer).to have_received(:some_errors)
      end
    end
  end

  context "в ответе errorCode отличный от 0" do
    before do
      @response = { errorCode: rand(1..26), orderId: "order-id", formUrl: "url" }
      stub_request(
        :get, Api::Pays::Sber.order_register
      ).to_return(status: 200, body: @response.to_json)
      @result = described_class.new(params: {}).call
    end

    it "вернет отрицательный результат" do
      expect(@result).to be_failure
    end

    it "вернет верные данные" do
      expect(@result.failure).to eq({ key: :error_code, data: @response })
    end

    it "отправит письмо об ошибке" do
      expect(DevelopmentMailer).to have_received(:some_errors)
    end
  end

  [
    Faraday::ServerError, Faraday::BadRequestError, Faraday::UnauthorizedError,
    Faraday::ForbiddenError, Faraday::ResourceNotFound, Faraday::ProxyAuthError,
    Faraday::RequestTimeoutError, Faraday::ConflictError, Faraday::UnprocessableEntityError,
    Faraday::ClientError
  ].each do |exception|
    context "при ошибке: #{exception}" do
      before do
        service = described_class.new(params: {})
        allow(service).to receive(:send_request).and_raise(exception)
        @result = service.call
      end

      it "вернет отрицательный результат" do
        expect(@result).to be_failure
      end

      it "отправит письмо об ошибке" do
        expect(DevelopmentMailer).to have_received(:some_errors)
      end
    end
  end
end
