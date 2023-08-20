#!/bin/bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

if [ "$HTTPS_ENABLE" = true ]; then
  PUBLIC_HOST="https://$HOSTNAME"
else
  PUBLIC_HOST="http://$HOSTNAME"
fi

cd /robotics-openproject

RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE RAILS_SERVE_STATIC_FILES=true PUBLIC_HOST=$PUBLIC_HOST npm run serve
