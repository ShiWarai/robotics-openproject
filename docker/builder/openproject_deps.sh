#!/bin/bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

cd /robotics-openproject

# Activate the exact toolchain versions required by the sources.
# `install -s` skips the (slow) build when the version is already present in
# the shared /root volume; otherwise it compiles it once, then caches it there.
RUBY_VERSION="$(cat .ruby-version)"
NODE_VERSION="$(cat .node-version 2>/dev/null)"
[ -n "$RUBY_VERSION" ] && { rbenv install -s "$RUBY_VERSION" || rbenv install "$RUBY_VERSION"; rbenv global "$RUBY_VERSION"; }
[ -n "$NODE_VERSION" ] && { nodenv install -s "$NODE_VERSION" || nodenv install "$NODE_VERSION"; nodenv global "$NODE_VERSION"; }

# Use the bundler version pinned by the Gemfile.lock (BUNDLED WITH)
BUNDLER_VERSION="$(grep -A1 '^BUNDLED WITH$' Gemfile.lock | tail -1 | tr -d '[:space:]')"
[ -z "$BUNDLER_VERSION" ] && BUNDLER_VERSION="4.0.20"
gem install --default bundler -v "$BUNDLER_VERSION"

bundle install
