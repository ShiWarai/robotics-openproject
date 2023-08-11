#!/bin/bash

cd /robotics-openproject

updated=0
if [ ! -d ".git" ]; then # Install
  git clone https://github.com/ShiWarai/robotics-openproject.git --branch stable /robotics-openproject
  mv /home/configuration.yml /robotics-openproject/config/configuration.yml
  rm -rf /robotics-openproject/tmp/cache
  updated=1
else # Update
  git fetch
  updated=$(git pull)
fi

rm -rf /robotics-openproject/tmp/pids
if [ "$updated" != "Already up to date." ]; then
  /home/openproject_deps.sh && /home/openproject_migrate.sh && /home/openproject_compile.sh
fi
