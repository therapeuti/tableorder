#!/bin/bash
# 수동 배포 스크립트 (Docker Hub 이미지 사용)

set -e

DOCKER_IMAGE="${DOCKER_IMAGE:-tableorder:latest}"

echo "=== 수동 배포 시작 ==="

# 프로젝트 디렉토리로 이동
cd /home/ubuntu/tableorder

# 환경 파일 확인
if [ ! -f .env ]; then
    echo "환경 파일 생성 중..."
    cat > .env << EOF
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,your-ec2-ip-here
DOCKER_IMAGE=$DOCKER_IMAGE
EOF
    echo "⚠️  .env 파일을 편집하여 올바른 값을 설정하세요!"
fi

# 데이터 디렉토리 확인
mkdir -p data/db data/media
chmod -R 755 data

# 이전 컨테이너 정리
echo "이전 컨테이너 정리 중..."
docker-compose down --remove-orphans || true

# 최신 이미지 풀
echo "최신 Docker 이미지 풀 중..."
docker pull $DOCKER_IMAGE

# 애플리케이션 시작
echo "애플리케이션 시작 중..."
docker-compose up -d

# 헬스체크
echo "헬스체크 중..."
sleep 30
for i in {1..10}; do
    if curl -f http://localhost/admin/login/ >/dev/null 2>&1; then
        echo "✅ 애플리케이션이 정상적으로 시작됨"
        break
    fi
    echo "헬스체크 시도 $i/10"
    sleep 10
done

# 사용하지 않는 이미지 정리
echo "사용하지 않는 이미지 정리 중..."
docker image prune -f

# 상태 확인
echo "=== 배포 완료 ==="
docker-compose ps
echo ""
echo "관리자 계정 생성하려면 다음 명령어를 실행하세요:"
echo "docker-compose exec web python manage.py createsuperuser"