#!/bin/bash

docker-compose --env-file docker.env -f docker-compose.yml -p robotics-openproject up -d
