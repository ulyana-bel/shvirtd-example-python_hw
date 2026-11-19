#!/bin/bash

# Останавливаем скрипт при любой ошибке
set -e

REPO_URL="https://github.com/ulyana-bel/shvirtd-example-python_hw.git"
TARGET_DIR="/opt/shvirtd-example-python"

echo "=== 1. Cloning or updating a repository in $TARGET_DIR ==="
if [ -d "$TARGET_DIR" ]; then
    echo "The directory already exists. Updating the code..."
    cd "$TARGET_DIR"
    git pull
else
    git clone "$REPO_URL" "$TARGET_DIR"
    cd "$TARGET_DIR"
fi

echo "=== 2. Launching the project via Docker Compose ==="
docker compose up -d --build

echo "=== 3. Checking running containers ==="
docker ps
