# frozen_string_literal: true

module Api
  ##
  # Контроллер для взаимодействия с внешними сервисами
  #
  class ApiController < ActionController::API
    rescue_from Exception, with: :unknown_error
    before_action :ensure_json_request

    private
      def ensure_json_request
        return if Rails.env.development?
        return if request.format == :json
        return if request.headers["Content-Type"] == "application/json"

        head :not_acceptable and return
      end

      def unknown_error(err)
        puts err.inspect
        puts err.backtrace
        DevelopmentMailer.unknown_error(err)
        head :internal_server_error
      end
  end
end
