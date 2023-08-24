#!/bin/bash

cd /robotics-openproject

updated="Already up to date."
previous_hash=1
new_hash=0
if [ ! -d ".git" ] || [ $FORCE_UPDATE -eq 1 ]; then # Install
#  if [ $FORCE_UPDATE -eq 1 ]; then
#    rm -rf /robotics-openproject
#  fi

  git clone https://github.com/ShiWarai/robotics-openproject.git --branch $GIT_BRANCH /robotics-openproject
  mv /home/configuration.yml /robotics-openproject/config/configuration.yml
  rm -rf /robotics-openproject/tmp/cache

  updated=1
elif [ $AUTO_UPDATE -eq 1 ]; then # Update
  previous_hash=$(git rev-parse HEAD)
  git restore .
  git checkout $GIT_BRANCH
  git fetch
  updated=$(git pull --force)
  new_hash=$(git rev-parse HEAD)
fi

rm -rf /robotics-openproject/tmp/pids
if [ "$updated" != "Already up to date." ] || [ "$previous_hash" != "$new_hash" ]; then
  /home/openproject_deps.sh && /home/openproject_migrate.sh && /home/openproject_compile.sh
fi
