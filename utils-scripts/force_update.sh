#!/bin/bash

docker container stop $(docker ps -aq -f label=com.docker.compose.project=robotics-openproject)
docker container rm $(docker ps -aq -f label=com.docker.compose.project=robotics-openproject)
docker volume rm robotics_openproject_sources
docker image rm $(docker image ls -aq --filter "reference=*robotics_openproject*")
docker builder prune -f

utils-scripts/run.sh
