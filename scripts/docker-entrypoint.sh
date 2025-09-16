#!/bin/bash
set -e

echo "Starting Django application..."

# 정적 파일 수집
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear --verbosity=2

# Django admin 정적 파일 확인
echo "Checking Django installation..."
python -c "import django.contrib.admin; print('Django admin path:', django.contrib.admin.__file__)"
python -c "from django.contrib.staticfiles.finders import find; print('Admin base.css:', find('admin/css/base.css'))"

# 정적 파일 수집 결과 확인
echo "Checking collected static files..."
find /app/staticfiles -name "base.css" || echo "base.css not found"
ls -la /app/staticfiles/admin/ || echo "Admin directory not found"
ls -la /app/staticfiles/admin/css/ || echo "Admin CSS directory not found"

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