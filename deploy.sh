#!/bin/bash
# =============================================================
# CentOS Deployment Script for Announcement System
# Usage: chmod +x deploy.sh && ./deploy.sh
# =============================================================

set -e

TOMCAT_HOME=${TOMCAT_HOME:-/opt/tomcat}
APP_NAME="announcement"
WAR_FILE="target/${APP_NAME}.war"
DB_NAME="announcement_db"
DB_USER="root"
DB_PASS="password"   # <-- change this

echo "======================================"
echo " Announcement System - Deploy Script"
echo "======================================"

# 1. Build
echo "[1/4] Building WAR with Maven..."
mvn clean package -DskipTests
echo "      Build OK: ${WAR_FILE}"

# 2. Initialize DB (first time only)
echo "[2/4] Checking database..."
mysql -u "${DB_USER}" -p"${DB_PASS}" -e \
    "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || true

read -r -p "      Run SQL init script? (y/N): " run_sql
if [[ "$run_sql" =~ ^[Yy]$ ]]; then
    mysql -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" < sql/init.sql
    echo "      Database initialized."
fi

# 3. Deploy WAR
echo "[3/4] Deploying WAR to Tomcat..."
if [ -d "${TOMCAT_HOME}/webapps/${APP_NAME}" ]; then
    rm -rf "${TOMCAT_HOME}/webapps/${APP_NAME}"
fi
if [ -f "${TOMCAT_HOME}/webapps/${APP_NAME}.war" ]; then
    rm -f "${TOMCAT_HOME}/webapps/${APP_NAME}.war"
fi
cp "${WAR_FILE}" "${TOMCAT_HOME}/webapps/${APP_NAME}.war"
echo "      WAR copied to ${TOMCAT_HOME}/webapps/"

# 4. Restart Tomcat
echo "[4/4] Restarting Tomcat..."
"${TOMCAT_HOME}/bin/shutdown.sh" 2>/dev/null || true
sleep 3
"${TOMCAT_HOME}/bin/startup.sh"

echo ""
echo "======================================"
echo " Deployment complete!"
echo " URL: http://$(hostname -I | awk '{print $1}'):8080/${APP_NAME}/"
echo "======================================"
