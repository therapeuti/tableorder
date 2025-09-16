#!/bin/bash
set -e

echo "Starting Django application..."

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