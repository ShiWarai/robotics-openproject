#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

# Delete all project data
read -p "Do you want to clear and delete containers? (y/n): " answer

if [ "$answer" == "y" ]; then
    utils-scripts/save_db.sh

    # Команды для очистки и удаления контейнеров
    docker stop $(docker ps -aq)  # Остановка всех контейнеров
    docker rm $(docker ps -aq)    # Удаление всех остановленных контейнеров

    docker container rm -f $(docker ps -aq -f label=com.docker.compose.project=robotics-openproject)
    docker image prune -af
    docker volume rm -f $(docker volume ls -q --filter name=robotics_openproject_*)
    docker builder prune -af

    echo -e "${RED}Containers cleared and deleted."
else
    exit 1
fi

exit 0
