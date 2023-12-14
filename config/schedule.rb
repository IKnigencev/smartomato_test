set :output, "log/cron.log"

# Решение для запуска крон задач в контейнере
ENV.each { |k, v| env(k, v) }

# Создание случайного заказа
every 1.minute do
  rake "rand_order:create", environment: :development
end
