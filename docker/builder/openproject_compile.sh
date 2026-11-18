#!/bin/bash

if [ ! -d "/robotics-openproject/tmp/pids" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - bash)"
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"

  cd /robotics-openproject

  # Ensure the toolchain versions the sources require are active
  RUBY_VERSION="$(cat .ruby-version 2>/dev/null)"
  NODE_VERSION="$(cat .node-version 2>/dev/null)"
  [ -n "$RUBY_VERSION" ] && rbenv global "$RUBY_VERSION"
  [ -n "$NODE_VERSION" ] && nodenv global "$NODE_VERSION"

  rm -rf public/assets >> log/setup.log
  (cd frontend && npm ci) >> log/setup.log
  bundle exec rake openproject:plugins:register_frontend DATABASE_URL=$DB_URL
  bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE DATABASE_URL=$DB_URL
fi
