FROM ruby:3.2.2-slim

# Установка нужных зависимостей
RUN apt-get update && apt-get install -y build-essential \
                                         libssl-dev \
                                         libreadline-dev \
                                         wget \
                                         git-all \
                                         cron \
                                         postgresql \
                                         postgresql-contrib \
                                         libpq-dev \
                                         apt-transport-https \
                                         ca-certificates
RUN apt-get clean

# Создание рабочей директории
WORKDIR /app

# Копирование приложения
COPY . ./

# Запуск приложения
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
