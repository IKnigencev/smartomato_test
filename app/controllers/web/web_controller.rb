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
      puts err.inspect
      puts err.backtrace
      DevelopmentMailer.unknown_error(err)
      redirect_to web_unknown_error_path
    end

    def not_found
      redirect_to web_not_found_path
    end
  end
end
