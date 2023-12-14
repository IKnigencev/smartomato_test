#!/bin/sh
set -e
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle check || bundle install

RAILS_ENV=development bin/rails db:drop
RAILS_ENV=development bin/rails db:create
RAILS_ENV=development bin/rails db:migrate
RAILS_ENV=development bin/rails db:seed

cron && bundle exec whenever --set 'environment=development' --update-crontab

bin/rails s -b 0.0.0.0 -p 3005
