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

# Django 정적 파일 확인 및 수집
RUN python -c "import django; django.setup(); from django.contrib.staticfiles.finders import find; print('Django admin CSS:', find('admin/css/base.css'))"
RUN python manage.py collectstatic --noinput --clear --verbosity=2 || echo "collectstatic failed"
RUN find /app/staticfiles -name "*.css" | head -10 || echo "No CSS files found"
RUN ls -la /app/staticfiles/admin/ || echo "Admin directory not found"

# 엔트리포인트 스크립트 복사 및 권한 설정
COPY scripts/docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# 포트 노출
EXPOSE 8000

# 엔트리포인트 설정
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# 애플리케이션 실행 (Django 개발서버 - 소규모 서비스용)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]