#!/bin/bash

set -e

# 1. Подгружаем переменные из файла .env (не храним пароли в коде!)
ENV_FILE="/opt/shvirtd-example-python/.env"
if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "Error: file $ENV_FILE not found!"
    exit 1
fi

# 2. Настраиваем директорию для бэкапов и имя файла с датой и временем
BACKUP_DIR="/opt/backup"
mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/dump_${MYSQL_DATABASE}_${TIMESTAMP}.sql"

# 3. Запускаем одноразовый контейнер mysqldump в сети проекта
docker run --rm \
  --entrypoint sh \
  --network shvirtd-example-python_backend \
  schnitzler/mysqldump \
  -c "apk add --no-cache mariadb-connector-c >/dev/null 2>&1 && mysqldump --no-tablespaces -h db -u\"$MYSQL_USER\" -p\"$MYSQL_PASSWORD\" \"$MYSQL_DATABASE\"" > "$BACKUP_FILE"


echo "Backup successfully created: $BACKUP_FILE"
