# Python 3.11 이미지 사용
FROM python:3.11-slim

# 시스템 의존성 설치
RUN apt-get update && apt-get install -y \
    sqlite3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# Python 의존성 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 코드 복사
COPY . .

# 환경변수 설정 (프로덕션 모드)
ENV DJANGO_SETTINGS_MODULE=restaurant_system.settings
ENV DJANGO_ENV=production
ENV DEBUG=False

# SQLite 데이터베이스 및 정적 파일 디렉토리 생성
RUN mkdir -p /app/data/db /app/data/media /app/staticfiles

# 정적 파일 수집
RUN python manage.py collectstatic --noinput --clear --verbosity=2

# Django admin 정적 파일 강제 복사
RUN python fix_admin_static.py

RUN ls -la /app/staticfiles/admin/css/ || echo "Admin CSS still not found"

# 엔트리포인트 스크립트 복사 및 권한 설정
COPY scripts/docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# 포트 노출
EXPOSE 8000

# 엔트리포인트 설정
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# 애플리케이션 실행 (Gunicorn - 프로덕션용)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "restaurant_system.wsgi:application"]