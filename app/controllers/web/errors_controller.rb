# frozen_string_literal: true

module Web
  ##
  # Выдача страниц с ошибками
  #
  class ErrorsController < WebController
    ##
    # Страница 404
    #
    def not_found; end

    ##
    # Ошибка на стороне сервера
    #
    def unknown_error; end
  end
end
