#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

tag_folder=""
if [ "$1" == "--tag" ]; then
  tag_folder="dumps/$2"
else
  # Find last
  tag_folder=$(find dumps/* -type d -printf '%T+\t%p\n' | sort | tail -1 | cut -f2-)
fi

# Check tag folder
if [ -d "$tag_folder" ]; then
  echo -e "Tag $tag_folder"

  if docker start $(docker ps -aq --filter name=robotics_openproject_db); then
    if docker ps -aq --filter name=robotics_openproject_builder | grep -q .; then
      docker cp $tag_folder/files $(docker ps -aq --filter name=robotics_openproject_builder):/robotics-openproject/
    else
      echo -e "${RED}Unable to find the build container to access files"
      exit 1
    fi
    cat $tag_folder/dump.sql | docker exec -i $(docker ps -aq --filter name=robotics_openproject_db) psql -U openproject
  else
    echo -e "${RED}Unable to find the database container"
    exit 1
  fi

  echo -e "${GREEN}Restored"
  exit 0
else
  echo -e "${RED}Unable to find tag \"$tag_folder\""
  exit 1
fi
