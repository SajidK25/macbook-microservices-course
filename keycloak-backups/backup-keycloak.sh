#!/bin/bash
echo "========================================"
echo "   Keycloak Backup - With Realm Log"
echo "========================================"

CONTAINER_NAME="keycloak"
BACKUP_DIR="$(pwd)"
DATE_TIME=$(date "+%Y%m%d-%H%M%S")
BACKUP_FILE="$BACKUP_DIR/keycloak-backup-$DATE_TIME.json"

mkdir -p "$BACKUP_DIR"

echo "1. Stopping Keycloak container..."
docker stop $CONTAINER_NAME

echo "2. Exporting data..."
docker run --rm \
  -v keycloak_data:/opt/keycloak/data \
  -v "$BACKUP_DIR":/backup \
  quay.io/keycloak/keycloak:26.2.5 \
  export --file /backup/keycloak-backup-$DATE_TIME.json --users same_file --optimized

echo "3. Restarting Keycloak container..."
docker start $CONTAINER_NAME

echo "4. Listing exported realms..."
REALMS=$(grep -o '"realm" *: *"[^"]*"' "$BACKUP_FILE" | sed 's/.*: *"//' | sed 's/"//')
echo "✅ Realms backed up: $REALMS"

echo "========================================"
echo "✅ Backup completed!"
echo "📁 File: $BACKUP_FILE"
echo "========================================"
