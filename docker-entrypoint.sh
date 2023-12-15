#!/bin/sh
set -e
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle check || bundle install

bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

cron && bundle exec whenever --set 'environment=development' --update-crontab

bin/rails s -b 0.0.0.0 -p 3005
