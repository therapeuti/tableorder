from .production import *

# Staging 환경 특별 설정
DEBUG = True  # 스테이징에서는 디버깅 허용

# 스테이징 도메인
ALLOWED_HOSTS = ['staging.your-domain.com', 'staging-server-ip']

# 보안 설정 완화
SECURE_SSL_REDIRECT = False
SESSION_COOKIE_SECURE = False
CSRF_COOKIE_SECURE = False

# 로깅 레벨 증가
LOGGING['root']['level'] = 'DEBUG'
LOGGING['loggers']['django']['level'] = 'DEBUG'