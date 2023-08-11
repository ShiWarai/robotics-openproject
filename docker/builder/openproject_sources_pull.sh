#!/bin/bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

cd /robotics-openproject
if [ ! -d ".git" ]; then # Install
  git clone https://github.com/ShiWarai/robotics-openproject.git --branch dev /robotics-openproject
else # Update
  git fetch
  git pull
fi
