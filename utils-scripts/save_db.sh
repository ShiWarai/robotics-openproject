#!/bin/bash

docker exec -t $(docker ps -aq --filter name=robotics_openproject_db) pg_dump -U openproject -c openproject > ../dumps/dump.sql
