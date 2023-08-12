#!/bin/bash

docker cp dumps/files $(docker ps -aq --filter name=robotics_openproject_builder):/robotics-openproject/
cat dumps/dump.sql | docker exec -i $(docker ps -aq --filter name=robotics_openproject_db) psql -U openproject
