# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::PayCallbackController do
  let(:order) { create(:order, status: :start) }

  describe "#successful" do
    context "положительный сценарий" do
      before do
        get :successful, params: stub_success_callback, format: :json
      end

      it "вернет 302" do
        expect(response).to have_http_status(:found)
      end

      it "перевед на верную страницу" do
        expect(response).to redirect_to(success_web_pay_path(order.id))
      end
    end

    context "сервис вернул ошибку" do
      before do
        result = proc { Dry::Monads::Result::Failure.new(:fail) }
        allow(Api::Pays::SberOrderCallbackOperation).to receive(:new).and_return(result)
        get :successful, params: stub_success_callback, format: :json
      end

      it "вернет 302" do
        expect(response).to have_http_status(:found)
      end

      it "перевед на верную страницу" do
        expect(response).to redirect_to(web_unknown_error_path)
      end
    end

    context "статус заказа не равен start" do
      before do
        order.update!(status: :init)
        get :failed, params: stub_success_callback, format: :json
      end

      it "вернет 404" do
        expect(response).to have_http_status(:not_found)
      end

      it "не перевед на верную страницу" do
        expect(response).not_to redirect_to(success_web_pay_path(order.id))
      end
    end
  end

  describe "#failed" do
    context "положительный сценарий" do
      before do
        get :failed, params: stub_failure_callback, format: :json
      end

      it "вернет 302" do
        expect(response).to have_http_status(:found)
      end

      it "перевед на верную страницу" do
        expect(response).to redirect_to(failure_web_pay_path(order.id))
      end
    end

    context "сервис вернул ошибку" do
      before do
        result = proc { Dry::Monads::Result::Failure.new(:fail) }
        allow(Api::Pays::SberOrderCallbackOperation).to receive(:new).and_return(result)
        get :failed, params: stub_failure_callback, format: :json
      end

      it "вернет 302" do
        expect(response).to have_http_status(:found)
      end

      it "перевед на верную страницу" do
        expect(response).to redirect_to(web_unknown_error_path)
      end
    end

    context "статус заказа не равен start" do
      before do
        order.update!(status: :init)
        get :failed, params: stub_failure_callback, format: :json
      end

      it "вернет 404" do
        expect(response).to have_http_status(:not_found)
      end

      it "не перевед на верную страницу" do
        expect(response).not_to redirect_to(failure_web_pay_path(order.id))
      end
    end
  end

  def stub_success_callback
    { orderNumber: order.id, operation: "", callbackCreationDate: Time.current, status: 1 }
  end

  def stub_failure_callback
    { orderNumber: order.id, operation: "", callbackCreationDate: Time.current, status: 0 }
  end
end
