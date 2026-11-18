#!/bin/bash
# Weekly backup (cron): DB dump + attachment files from the k3s cluster.
# Layout kept compatible with restore_db.sh: dumps/<tag>/dump.sql + dumps/<tag>/files/
set -euo pipefail
RED='\033[0;31m'
GREEN='\033[0;32m'
NS="${KUBECTL_NAMESPACE:-rtuitlab}"

tag_name=$(date +"%Y-%m-%d_%H-%M-%S")
mkdir -p "dumps/$tag_name"

db_pod=$(kubectl get pod -n "$NS" -l app=openproject-db -o jsonpath='{.items[0].metadata.name}')
web_pod=$(kubectl get pod -n "$NS" -l app=openproject -o jsonpath='{.items[0].metadata.name}')

if [ -z "$db_pod" ] || [ -z "$web_pod" ]; then
  echo -e "${RED}Unable to find openproject pods in namespace $NS"
  exit 1
fi

kubectl exec -n "$NS" "$db_pod" -- pg_dump -U openproject -c openproject > "dumps/$tag_name/dump.sql"
kubectl cp "$NS/$web_pod:/app/files" "dumps/$tag_name/files" -c web

echo -e "${GREEN}Saved dumps/$tag_name"
exit 0
