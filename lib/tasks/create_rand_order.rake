# frozen_string_literal: true

namespace :rand_order do
  desc "Создание случайного заказа"
  task create: :environment do
    Web::Order::RandCreateService.call
  rescue Exception => e
    DevelopmentMailer.unknown_error(e)
  end
end
