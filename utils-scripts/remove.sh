#!/bin/bash

# Save DB
./save_db.sh
# Delete all project data
docker container rm -f $(docker ps -aq -f label=com.docker.compose.project=robotics-openproject)
docker image prune -af
docker volume rm -f $(docker volume ls -q --filter name=robotics_openproject_*)
docker builder prune -af
