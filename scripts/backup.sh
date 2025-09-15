#!/bin/bash

set -e

# 백업 디렉토리 생성
BACKUP_DIR="/home/ubuntu/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

echo "📦 Starting backup to $BACKUP_DIR..."

# 데이터베이스 백업
echo "🗄️  Backing up database..."
docker-compose exec -T db pg_dump -U ${DB_USER} ${DB_NAME} > $BACKUP_DIR/db_backup.sql

# 미디어 파일 백업
echo "📁 Backing up media files..."
cp -r media $BACKUP_DIR/

# 설정 파일 백업
echo "⚙️  Backing up configuration files..."
cp .env $BACKUP_DIR/
cp docker-compose.yml $BACKUP_DIR/

# 압축
echo "🗜️  Compressing backup..."
tar -czf $BACKUP_DIR.tar.gz -C $(dirname $BACKUP_DIR) $(basename $BACKUP_DIR)
rm -rf $BACKUP_DIR

# 오래된 백업 삭제 (30일 이상)
echo "🧹 Cleaning old backups..."
find /home/ubuntu/backups -name "*.tar.gz" -mtime +30 -delete

# AWS S3 업로드 (선택사항)
if [ ! -z "$AWS_S3_BUCKET" ]; then
    echo "☁️  Uploading to S3..."
    aws s3 cp $BACKUP_DIR.tar.gz s3://$AWS_S3_BUCKET/backups/
fi

echo "✅ Backup completed: $BACKUP_DIR.tar.gz"