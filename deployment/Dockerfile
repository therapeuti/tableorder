# Python 3.11 이미지 사용
FROM python:3.11-slim

# 작업 디렉토리 설정
WORKDIR /app

# Python 의존성 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir Django==5.2.6 Pillow==11.3.0 qrcode[pil]==8.2 django-cors-headers==4.7.0 gunicorn django-debug-toolbar

# 애플리케이션 코드 복사
COPY . .

# 환경변수 설정 (프로덕션 모드)
ENV DJANGO_SETTINGS_MODULE=restaurant_system.settings
ENV DEBUG=False

# SQLite 데이터베이스 파일이 없으면 초기 마이그레이션 실행
RUN python manage.py migrate --run-syncdb

# 정적 파일 수집
RUN python manage.py collectstatic --noinput

# 포트 노출
EXPOSE 8000

# 애플리케이션 실행
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "restaurant_system.wsgi:application"]