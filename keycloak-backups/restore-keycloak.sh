#!/bin/bash
echo "========================================"
echo "   Ultimate Keycloak Restore Fix"
echo "========================================"

read -p "Enter backup file: " BACKUP_FILE

# Complete reset
docker stop keycloak-restored 2>/dev/null; docker rm keycloak-restored 2>/dev/null; docker volume rm keycloak_restored_data 2>/dev/null

# Start fresh Keycloak first
docker run -d --name keycloak-temp -p 8445:8080 \
  -e KEYCLOAK_ADMIN=tempuser \
  -e KEYCLOAK_ADMIN_PASSWORD=temp123 \
  quay.io/keycloak/keycloak:26.2.5 start-dev

echo "Waiting for fresh Keycloak to start..."
sleep 60

# Stop and get its volume
docker stop keycloak-temp
TEMP_VOLUME=$(docker inspect keycloak-temp --format='{{range .Mounts}}{{if eq .Destination "/opt/keycloak/data"}}{{.Name}}{{end}}{{end}}')

# Import your backup into this working volume
docker run --rm \
  -v $TEMP_VOLUME:/opt/keycloak/data \
  -v "$(pwd)":/restore \
  quay.io/keycloak/keycloak:26.2.5 \
  import --file /restore/$BACKUP_FILE

# Start final container with working admin
docker rm keycloak-temp
docker run -d --name keycloak-restored -p 8444:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin123 \
  -v $TEMP_VOLUME:/opt/keycloak/data \
  quay.io/keycloak/keycloak:26.2.5 start-dev

echo "Final startup..."
sleep 60

echo "========================================"
echo "✅ Ultimate restore completed!"
echo "🌐 Access: http://localhost:8444/admin/"
echo "👤 Username: admin"
echo "🔑 Password: admin123"
echo "========================================"
