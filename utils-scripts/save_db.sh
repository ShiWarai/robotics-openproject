#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

# Current date as tag for dump
tag_name=$(date +"%Y-%m-%d_%H-%M-%S")

if docker start $(docker ps -aq --filter name=robotics_openproject_db); then
  if docker ps -aq --filter name=robotics_openproject_builder | grep -q .; then
    docker cp $(docker ps -aq --filter name=robotics_openproject_builder):/robotics-openproject/files dumps/$tag_name
  else
    echo -e "${RED}Unable to find the build container to access files"
    exit 1
  fi
  docker exec -t $(docker ps -aq --filter name=robotics_openproject_db) pg_dump -U openproject -c openproject > dumps/$tag_name/dump.sql
else
  echo -e "${RED}Unable to find the database container"
  exit 1
fi

echo -e "${GREEN}Saved"
exit 0
