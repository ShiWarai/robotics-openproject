#!/bin/bash

if [ ! -d "/robotics-openproject/tmp/pids" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - bash)"
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"

  cd /robotics-openproject

  rm -rf public/assets >> log/setup.log
  (cd frontend && npm ci) >> log/setup.log
  bundle exec rake openproject:plugins:register_frontend DATABASE_URL=$DB_URL
  bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE DATABASE_URL=$DB_URL
fi
