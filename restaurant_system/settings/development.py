from .base import *

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-9v8mjfikrbdx)(&#58_xo5-16o$)5fj&9@k76e&$ss_&xqb#(j')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'INFO',
    },
}

# Development tools (debug_toolbar 제거됨)
# INSTALLED_APPS += [
#     'debug_toolbar',
# ]

# MIDDLEWARE = [
#     'debug_toolbar.middleware.DebugToolbarMiddleware',
# ] + MIDDLEWARE

# INTERNAL_IPS = [
#     '127.0.0.1',
# ]