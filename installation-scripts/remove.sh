# Save DB
docker exec -t $(docker ps -aq --filter name=robotics_openproject_db) pg_dump -U openproject -c openproject > dump.sql
# Delete all project data
docker container stop $(docker ps -aq -f label=com.docker.compose.project=robotics-openproject) && docker image prune -af && docker volume prune -f && docker builder prune -af
