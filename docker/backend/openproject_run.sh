#!/bin/bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

cd /robotics-openproject

rm -rf tmp/pids
RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE RAILS_SERVE_STATIC_FILES=true OPENPROJECT_HTTPS=false DATABASE_URL=postgresql://openproject:$DB_PASSWORD@$DB_ADDRESS/openproject bundle exec rails server
