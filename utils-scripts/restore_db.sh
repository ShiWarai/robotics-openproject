#!/bin/bash
# Restore DB dump + attachment files into the k3s cluster.
# Usage: ./utils-scripts/restore_db.sh [--tag <tag>]
set -euo pipefail
RED='\033[0;31m'
GREEN='\033[0;32m'
NS="${KUBECTL_NAMESPACE:-rtuitlab}"

tag_folder=""
if [ "$1" == "--tag" ]; then
  tag_folder="dumps/$2"
else
  # Find last
  tag_folder=$(find dumps/* -type d -printf '%T+\t%p\n' | sort | tail -1 | cut -f2-)
fi

if [ ! -d "$tag_folder" ]; then
  echo -e "${RED}Unable to find tag \"$tag_folder\""
  exit 1
fi
echo -e "Tag $tag_folder"

db_pod=$(kubectl get pod -n "$NS" -l app=openproject-db -o jsonpath='{.items[0].metadata.name}')
web_pod=$(kubectl get pod -n "$NS" -l app=openproject -o jsonpath='{.items[0].metadata.name}')

if [ -z "$db_pod" ] || [ -z "$web_pod" ]; then
  echo -e "${RED}Unable to find openproject pods in namespace $NS"
  exit 1
fi

if [ -d "$tag_folder/files" ]; then
  kubectl cp "$tag_folder/files" "$NS/$web_pod:/app/" -c web
fi
kubectl exec -i -n "$NS" "$db_pod" -- psql -U openproject -d openproject < "$tag_folder/dump.sql"

echo -e "${GREEN}Restored"
exit 0
