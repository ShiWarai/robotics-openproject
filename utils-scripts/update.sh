#!/bin/bash

./save_db.sh

docker container stop $(docker ps -aq -f label=com.docker.compose.project=robotics-openproject | grep -vF "$(docker ps -aq -f name=robotics_openproject_db -f name=robotics_openproject_builder)")
docker-compose --env-file ../docker.env -f ../docker-compose.yml -p robotics-openproject build --no-cache robotics_openproject_builder

./run.sh
./restore_db.sh
