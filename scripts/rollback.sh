#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: ./rollback.sh <commit_hash>"
    echo "Available recent commits:"
    git log --oneline -n 10
    exit 1
fi

COMMIT_HASH=$1

echo "🔄 Rolling back to commit: $COMMIT_HASH"

# 현재 상태 백업
echo "💾 Creating backup before rollback..."
./scripts/backup.sh

# Git 롤백
echo "📝 Rolling back code..."
git checkout $COMMIT_HASH

# Docker 이미지 재빌드
echo "🔨 Rebuilding application..."
docker-compose build --no-cache

# 서비스 재시작
echo "🔄 Restarting services..."
docker-compose down
docker-compose up -d

# 헬스체크
echo "🏥 Performing health check..."
sleep 30

if curl -f http://localhost:8000/health/ > /dev/null 2>&1; then
    echo "✅ Rollback successful!"
    
    # Slack 알림
    if [ ! -z "$SLACK_WEBHOOK_URL" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"⚠️ TableOrder rolled back to commit: '"$COMMIT_HASH"'"}' \
            $SLACK_WEBHOOK_URL
    fi
else
    echo "❌ Rollback failed! Check logs:"
    docker-compose logs web
    exit 1
fi