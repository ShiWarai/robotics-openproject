#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

if docker start $(docker ps -aq --filter name=robotics_openproject_db); then
  if docker ps -aq --filter name=robotics_openproject_builder | grep -q .; then
    docker cp dumps/files $(docker ps -aq --filter name=robotics_openproject_builder):/robotics-openproject/
  else
    echo -e "${RED}Unable to find the build container to access files"
    exit 1
  fi
  cat dumps/dump.sql | docker exec -i $(docker ps -aq --filter name=robotics_openproject_db) psql -U openproject
else
  echo -e "${RED}Unable to find the database container"
  exit 1
fi

echo -e "${GREEN}Saved"
exit 0
