from django.core.management.base import BaseCommand
from django.conf import settings
import os

class Command(BaseCommand):
    help = 'Static files 설정과 수집 상태를 확인합니다'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('=== Static Files 설정 확인 ==='))

        # 설정 정보 출력
        self.stdout.write(f'STATIC_URL: {settings.STATIC_URL}')
        self.stdout.write(f'STATIC_ROOT: {settings.STATIC_ROOT}')
        self.stdout.write(f'STATICFILES_DIRS: {settings.STATICFILES_DIRS}')

        # STATIC_ROOT 디렉토리 존재 확인
        if os.path.exists(settings.STATIC_ROOT):
            self.stdout.write(self.style.SUCCESS(f'✓ STATIC_ROOT 디렉토리 존재: {settings.STATIC_ROOT}'))

            # admin 관련 파일 확인
            admin_css_path = os.path.join(settings.STATIC_ROOT, 'admin', 'css')
            admin_js_path = os.path.join(settings.STATIC_ROOT, 'admin', 'js')

            if os.path.exists(admin_css_path):
                css_files = os.listdir(admin_css_path)
                self.stdout.write(self.style.SUCCESS(f'✓ Admin CSS 파일 수: {len(css_files)}'))
                self.stdout.write(f'  CSS 파일들: {", ".join(css_files[:5])}{"..." if len(css_files) > 5 else ""}')
            else:
                self.stdout.write(self.style.ERROR(f'✗ Admin CSS 디렉토리 없음: {admin_css_path}'))

            if os.path.exists(admin_js_path):
                js_files = os.listdir(admin_js_path)
                self.stdout.write(self.style.SUCCESS(f'✓ Admin JS 파일 수: {len(js_files)}'))
                self.stdout.write(f'  JS 파일들: {", ".join(js_files[:5])}{"..." if len(js_files) > 5 else ""}')
            else:
                self.stdout.write(self.style.ERROR(f'✗ Admin JS 디렉토리 없음: {admin_js_path}'))

            # 전체 수집된 파일 수
            total_files = sum(len(files) for _, _, files in os.walk(settings.STATIC_ROOT))
            self.stdout.write(f'전체 수집된 정적 파일 수: {total_files}')

        else:
            self.stdout.write(self.style.ERROR(f'✗ STATIC_ROOT 디렉토리 없음: {settings.STATIC_ROOT}'))

        # Django admin app 확인
        if 'django.contrib.admin' in settings.INSTALLED_APPS:
            self.stdout.write(self.style.SUCCESS('✓ django.contrib.admin이 INSTALLED_APPS에 포함됨'))
        else:
            self.stdout.write(self.style.ERROR('✗ django.contrib.admin이 INSTALLED_APPS에 없음'))

        if 'django.contrib.staticfiles' in settings.INSTALLED_APPS:
            self.stdout.write(self.style.SUCCESS('✓ django.contrib.staticfiles가 INSTALLED_APPS에 포함됨'))
        else:
            self.stdout.write(self.style.ERROR('✗ django.contrib.staticfiles가 INSTALLED_APPS에 없음'))