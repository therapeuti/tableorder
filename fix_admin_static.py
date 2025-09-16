#!/usr/bin/env python
"""Django admin 정적 파일 강제 복사 스크립트"""

import os
import shutil
import django
from pathlib import Path

# Django 설정
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'restaurant_system.settings')
django.setup()

def copy_admin_static():
    """Django admin 정적 파일을 강제로 복사"""
    import django.contrib.admin
    
    # 소스와 대상 경로
    admin_static_source = Path(django.contrib.admin.__file__).parent / 'static' / 'admin'
    admin_static_dest = Path('/app/staticfiles/admin')
    
    print(f"Source: {admin_static_source}")
    print(f"Destination: {admin_static_dest}")
    
    if admin_static_source.exists():
        # 기존 디렉토리 삭제
        if admin_static_dest.exists():
            shutil.rmtree(admin_static_dest)
            print("Removed existing admin static directory")
        
        # 새로 복사
        shutil.copytree(admin_static_source, admin_static_dest)
        print("Admin static files copied successfully")
        
        # 확인
        css_files = list(admin_static_dest.glob('css/*.css'))
        js_files = list(admin_static_dest.glob('js/*.js'))
        print(f"CSS files: {len(css_files)}")
        print(f"JS files: {len(js_files)}")
        
    else:
        print(f"Admin static source not found: {admin_static_source}")

if __name__ == '__main__':
    copy_admin_static()