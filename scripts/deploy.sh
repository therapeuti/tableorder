#!/bin/bash

set -e

echo "🚀 Starting deployment..."

# 환경 변수 로드
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Git 업데이트
echo "📥 Pulling latest code..."
git pull origin main

# Docker 이미지 빌드
echo "🔨 Building Docker image..."
docker-compose build --no-cache

# 서비스 중단
echo "⏹️  Stopping services..."
docker-compose down

# 데이터베이스 마이그레이션
echo "🗄️  Running migrations..."
docker-compose run --rm web python manage.py migrate

# 정적 파일 수집
echo "📁 Collecting static files..."
docker-compose run --rm web python manage.py collectstatic --noinput

# 서비스 시작
echo "▶️  Starting services..."
docker-compose up -d

# 헬스체크
echo "🏥 Performing health check..."
sleep 30

# 서비스 상태 확인
if curl -f http://localhost:8000/health/ > /dev/null 2>&1; then
    echo "✅ Deployment successful!"
    
    # Slack 알림 (선택사항)
    if [ ! -z "$SLACK_WEBHOOK_URL" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"🎉 TableOrder deployment successful!"}' \
            $SLACK_WEBHOOK_URL
    fi
else
    echo "❌ Health check failed!"
    docker-compose logs web
    exit 1
fi

# 이전 이미지 정리
echo "🧹 Cleaning up old images..."
docker system prune -f

echo "🎉 Deployment completed successfully!"