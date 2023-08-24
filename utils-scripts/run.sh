#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

if [[ $* == *-setup* ]] || ! (docker ps -aq -f label=com.docker.compose.project=robotics-openproject | grep -q .); then # First start
  echo "Setup..."
  FORCE_UPDATE=1 docker-compose --env-file docker.env -f docker-compose.yml -p robotics-openproject up -d --build
  utils-scripts/restore_db.sh
elif [[ $* == *-update* ]]; then
  echo "Try to update..."

  # Store dumps
  if utils-scripts/save_db.sh; then
    # Stop old containers
    docker stop $(docker ps -aq --filter name=robotics_openproject_backend --filter name=robotics_openproject_frontend --filter name=robotics_openproject_worker)
    # Run builder
    AUTO_UPDATE=1 FORCE_UPDATE=0 docker-compose --env-file docker.env -f docker-compose.yml -p robotics-openproject up -d

    # Restore dumps
    if ! utils-scripts/restore_db.sh; then
      exit 1
    fi
  else
    exit 1
  fi
else
  echo "Run..."

  AUTO_UPDATE=0 FORCE_UPDATE=0 docker-compose --env-file docker.env -f docker-compose.yml -p robotics-openproject up -d
fi

echo -e "${GREEN}Wait a few seconds for full run"
exit 0
