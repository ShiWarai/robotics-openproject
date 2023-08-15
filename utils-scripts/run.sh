#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

if [[ $* == *-setup* ]] || ! (docker ps -aq -f label=com.docker.compose.project=robotics-openproject | grep -q .); then # First start
  docker-compose --env-file docker.env -f docker-compose.yml -p robotics-openproject up -d
  utils-scripts/restore_db.sh
else
  # Store dumps
  if utils-scripts/save_db.sh; then
    # Stop old containers
    docker stop $(docker ps -aq --filter name=robotics_openproject_backend --filter name=robotics_openproject_frontend --filter name=robotics_openproject_worker)
    # Run builder
    docker-compose --env-file docker.env -f docker-compose.yml -p robotics-openproject up -d

    # Restore dumps
    if ! utils-scripts/restore_db.sh; then
      exit 1
    fi
  else
    exit 1
  fi
fi

echo "Wait a few seconds for full run..."
exit 0
