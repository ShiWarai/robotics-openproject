#!/bin/bash

cd /robotics-openproject

updated=0
if [ ! -d ".git" ] || [ $FORCE_UPDATE -eq 1 ]; then # Install
#  if [ $FORCE_UPDATE -eq 1 ]; then
#    rm -rf /robotics-openproject
#  fi

  git clone https://github.com/ShiWarai/robotics-openproject.git --branch stable /robotics-openproject
  mv /home/configuration.yml /robotics-openproject/config/configuration.yml
  rm -rf /robotics-openproject/tmp/cache

  updated=1
elif [ $AUTO_UPDATE -eq 1 ]; then # Update
  git fetch
  git reset --hard origin/stable
  updated=$(git pull --force)
else
  updated="Already up to date."
fi

rm -rf /robotics-openproject/tmp/pids
if [ "$updated" != "Already up to date." ]; then
  /home/openproject_deps.sh && /home/openproject_migrate.sh && /home/openproject_compile.sh
fi
