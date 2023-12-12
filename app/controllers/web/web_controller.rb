# frozen_string_literal: true

module Web
  ##
  # Для запросов из кабинета.
  #
  class WebController < ApplicationController
    rescue_from Exception, with: :unknown_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    before_action :set_cors_headers
    layout "web"

    def set_cors_headers
      response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, Authorization"
      response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
      response.headers["Access-Control-Allow-Origin"] = request.origin
      response.headers["Access-Control-Request-Method"] = "*"
    end

    def unknown_error(err)
      DevelopmentMailer.unknown_error(err)
      render "errors/500"
    end

    def not_found
      render "errors/404"
    end
  end
end
