# frozen_string_literal: true

require "rails_helper"

RSpec.describe Web::PaysController do
  let(:order) { create(:order, status: :start) }

  describe "#create" do
    context "положительный сценарий" do
      before do
        @response = proc { Dry::Monads::Result::Success.new(redirect_url: "https://example.com") }
        allow(Web::Pays::PayThroughSberOperation).to receive(:new).and_return(@response)
        post :create, params: { id: order.id }
      end

      it "вернет статус 302" do
        expect(response).to have_http_status(:found)
      end

      it "редирект на верную страницу" do
        expect(response).to redirect_to("https://example.com")
      end
    end

    context "сервис вернул ошибку" do
      before do
        @response = proc { Dry::Monads::Result::Failure.new(:some_errors) }
        allow(Web::Pays::PayThroughSberOperation).to receive(:new).and_return(@response)
        post :create, params: { id: order.id }
      end

      it "вернет статус 302" do
        expect(response).to have_http_status(:found)
      end

      it "редирект на верную страницу" do
        expect(response).to redirect_to(web_unknown_error_path)
      end
    end
  end

  described_class::CALLBACK_ACTIONS.each do |action|
    describe "##{action}" do
      before do
        get action, params: { id: order.id }
      end

      it "вернет статус 200" do
        expect(response).to have_http_status(:ok)
      end

      it "вернет верную страницу" do
        expect(response).to render_template("web/orders/show")
      end
    end
  end
end
