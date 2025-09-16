#!/bin/bash
# 백업 복원 스크립트

set -e

if [ $# -eq 0 ]; then
    echo "사용법: $0 <백업파일경로>"
    echo "예: $0 /home/ubuntu/backups/tableorder_backup_20241216_143000.tar.gz"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ 백업 파일이 존재하지 않습니다: $BACKUP_FILE"
    exit 1
fi

echo "=== 백업 복원 시작 ==="
echo "백업 파일: $BACKUP_FILE"

# 현재 애플리케이션 중지
echo "애플리케이션 중지 중..."
cd /home/ubuntu/tableorder
docker-compose down || true

# 현재 데이터 백업 (안전을 위해)
CURRENT_BACKUP="data_before_restore_$(date +%Y%m%d_%H%M%S).tar.gz"
echo "현재 데이터 백업 중: $CURRENT_BACKUP"
tar -czf "/home/ubuntu/backups/$CURRENT_BACKUP" data/ .env 2>/dev/null || true

# 백업 파일 압축 해제
echo "백업 파일 복원 중..."
tar -xzf "$BACKUP_FILE" -C /home/ubuntu/tableorder/

# 권한 설정
chmod -R 755 data/

# 애플리케이션 재시작
echo "애플리케이션 재시작 중..."
docker-compose up -d --build

# 헬스체크
echo "헬스체크 중..."
sleep 30
for i in {1..5}; do
    if curl -f http://localhost/admin/login/ >/dev/null 2>&1; then
        echo "✅ 복원 완료! 애플리케이션이 정상 작동 중입니다."
        exit 0
    fi
    echo "헬스체크 시도 $i/5"
    sleep 10
done

echo "⚠️  애플리케이션이 정상적으로 시작되지 않았습니다. 로그를 확인하세요:"
echo "docker-compose logs"