# frozen_string_literal: true

##
# Письма для разработчиков, ошибки и необходимые уведомления
#
class DevelopmentMailer < ApplicationMailer
  ##
  # Письмо о неизвестной ошибке
  #
  def unknown_error(error)
    @error = error
    mail(to: "dev@gmail.com", subject: "Exception")
  end

  def some_errors(error)
    @error = error
    mail(to: "dev@gmail.com", subject: "Some Error")
  end
end
