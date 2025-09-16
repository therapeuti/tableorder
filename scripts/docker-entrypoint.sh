#!/bin/bash
set -e

echo "Starting Django application..."

# 정적 파일 수집
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear --verbosity=2

# 정적 파일 수집 결과 확인
echo "Checking collected static files..."
find /app/staticfiles -name "base.css" || echo "base.css not found"
ls -la /app/staticfiles/admin/ || echo "Admin directory not found"
ls -la /app/staticfiles/admin/css/ || echo "Admin CSS directory not found"

# Django admin 정적 파일 수동 복사 (필요시)
if [ ! -d "/app/staticfiles/admin" ]; then
    echo "Manually copying Django admin static files..."
    python -c "
import os, shutil, django.contrib.admin
admin_static = os.path.join(os.path.dirname(django.contrib.admin.__file__), 'static', 'admin')
if os.path.exists(admin_static):
    shutil.copytree(admin_static, '/app/staticfiles/admin', dirs_exist_ok=True)
    print('Admin static files copied manually')
else:
    print('Admin static source not found')
"
fi

# 데이터베이스 마이그레이션
echo "Running database migrations..."
python manage.py migrate

# 초기 데이터 설정
echo "Setting up initial data..."
python manage.py setup_tables --count 20 --seats 4
python manage.py setup_menus

# 관리자 계정 생성 (이미 있으면 무시)
echo "Creating superuser if not exists..."
python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Superuser created: admin/admin123')
else:
    print('Superuser already exists')
EOF

echo "Starting Gunicorn server..."
exec "$@"