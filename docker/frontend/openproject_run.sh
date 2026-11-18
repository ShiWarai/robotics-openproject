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

# Activate the toolchain versions the sources were built with (shared /root volume)
RUBY_VERSION="$(cat .ruby-version 2>/dev/null)"
NODE_VERSION="$(cat .node-version 2>/dev/null)"
[ -n "$RUBY_VERSION" ] && rbenv global "$RUBY_VERSION"
[ -n "$NODE_VERSION" ] && nodenv global "$NODE_VERSION"

RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE RAILS_SERVE_STATIC_FILES=true PUBLIC_HOST=$PUBLIC_HOST npm run serve
