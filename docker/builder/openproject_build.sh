#!/bin/bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

cd /robotics-openproject
gem install --default bundler -v 2.4.17
gem update --system
cp config/database.yml.example config/database.yml
cp config/configuration.yml.example config/configuration.yml

bundle install
