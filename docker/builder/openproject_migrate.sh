#!/bin/bash

if [ ! -d "/robotics-openproject/tmp/cache" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - bash)"
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"

  cd /robotics-openproject

  bundle exec rake db:migrate RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE DATABASE_URL=postgresql://openproject:$DB_PASSWORD@$DB_ADDRESS/openproject
  bundle exec rake db:seed RAILS_ENV=production OPENPROJECT_DEFAULT_LANGUAGE=ru SECRET_KEY_BASE=$SECRET_KEY_BASE DATABASE_URL=postgresql://openproject:$DB_PASSWORD@$DB_ADDRESS/openproject
fi
