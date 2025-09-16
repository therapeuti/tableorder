#!/bin/bash
# SQLite 데이터베이스 백업 스크립트

set -e

BACKUP_DIR="/home/ubuntu/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="tableorder_backup_${TIMESTAMP}.tar.gz"

echo "=== SQLite 데이터베이스 백업 시작 ==="

# 백업 디렉토리 생성
mkdir -p $BACKUP_DIR

# 프로젝트 디렉토리로 이동
cd /home/ubuntu/tableorder

# 데이터 디렉토리 백업
echo "데이터 디렉토리 백업 중..."
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    data/ \
    .env \
    docker-compose.yml

echo "백업 완료: $BACKUP_DIR/$BACKUP_FILE"
echo "백업 크기: $(du -h $BACKUP_DIR/$BACKUP_FILE | cut -f1)"

# 30일 이상 된 백업 파일 삭제
echo "오래된 백업 파일 정리 중..."
find $BACKUP_DIR -name "tableorder_backup_*.tar.gz" -mtime +30 -delete

echo "=== 백업 완료 ==="
echo "현재 백업 파일들:"
ls -lh $BACKUP_DIR/tableorder_backup_*.tar.gz 2>/dev/null || echo "백업 파일 없음"