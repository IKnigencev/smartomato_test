# frozen_string_literal: true

##
# Базовый клиент через который работают все запросы
module Client::Connection
  include Client::Errors
  attr_reader :conn

  def call
    @conn = build_connection
    response = send_request
    raise Invalid.new(
      {
        status: response.status,
        body: response.body
      }
    ) unless response.success?

    response.body
  end

  private
    def build_connection
      Faraday.new(options) do |conn|
        conn.response :logger unless Rails.env.test?
        conn.response :raise_error, include_request: true
        conn.response :json, content_type: /\bjson$/, parser_options: parser_options
        conn.request :json
        conn.request :retry, retry_options
        conn.adapter Faraday.default_adapter
      end
    end

    def parser_options
      { symbolize_names: true }
    end

    def send_request; end

    def options
      options = {}
      options[:request] = { open_timeout: 5, timeout: 5 }
      options[:ssl] = { verify: verify_ssl }
      options[:headers] = headers
      options[:url] = webhook_url
      options[:params] = payload_params
      options
    end

    def verify_ssl
      true
    end

    def headers; end

    def api_method; end

    def base_url; end

    def webhook_url
      "#{base_url}#{api_method}"
    end

    def payload_params
      {}
    end

    ##
    # Описание ошибок: https://lostisland.github.io/faraday/#/middleware/included/raising-errors
    # Описание логики повторов: https://github.com/lostisland/faraday-retry
    # Повторяем ошибки 400-499 и 500-599
    def retry_options
      {
        max: 5,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2,
        exceptions: [
          Faraday::ServerError, Faraday::BadRequestError, Faraday::UnauthorizedError,
          Faraday::ForbiddenError, Faraday::ResourceNotFound, Faraday::ProxyAuthError,
          Faraday::RequestTimeoutError, Faraday::ConflictError, Faraday::UnprocessableEntityError,
          Faraday::ClientError
        ]
      }
    end

    def catch_exceptions
      block.call
    rescue Faraday::ClientError, Faraday::ServerError => e
      catched_faraday_exceptions(e)
    end

    def catched_faraday_exceptions(err)
      DevelopmentMailer.some_errors(err).deliver_later
      raise Invalid, err.inspect
    end
end
