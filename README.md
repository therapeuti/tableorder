# TableOrder - 레스토랑 주문 시스템

Django 기반의 QR코드를 이용한 레스토랑 테이블 주문 시스템

## 주요 기능

- 🏷️ QR코드 기반 테이블 주문
- 📱 모바일 친화적 인터페이스
- 🍽️ 메뉴 관리 시스템
- 📊 주문 관리 및 리포트
- 👨‍💼 관리자 대시보드

## 기술 스택

- **Backend**: Django 5.2.6
- **Database**: PostgreSQL (프로덕션), SQLite (개발)
- **Frontend**: HTML, CSS, JavaScript
- **Deployment**: Docker, Docker Compose
- **CI/CD**: GitHub Actions

## 로컬 개발 환경 설정

### 1. 저장소 클론
```bash
git clone <repository-url>
cd tableorder
```

### 2. 가상환경 생성 및 활성화
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 3. 의존성 설치
```bash
pip install -r requirements.txt
```

### 4. 데이터베이스 마이그레이션
```bash
python manage.py migrate
```

### 5. 관리자 계정 생성
```bash
python manage.py createsuperuser
```

### 6. 개발 서버 실행
```bash
python manage.py runserver
```

## Docker를 이용한 배포

### 1. 환경변수 설정
```bash
cp config/.env.example .env
# .env 파일을 편집하여 필요한 값들을 설정
```

### 2. Docker Compose 실행
```bash
docker-compose up -d --build
```

### 3. 관리자 계정 생성
```bash
docker-compose exec web python manage.py createsuperuser
```

## 프로젝트 구조

```
tableorder/
├── .github/workflows/     # GitHub Actions CI/CD
├── config/               # 환경 설정 파일들
├── deployment/           # Docker 및 배포 설정
├── scripts/              # 배포 스크립트
├── restaurant_system/    # Django 메인 프로젝트
├── tables/               # 테이블 관리 앱
├── orders/               # 주문 관리 앱  
├── menus/                # 메뉴 관리 앱
├── reports/              # 리포트 앱
├── templates/            # HTML 템플릿
├── static/               # 정적 파일
├── media/                # 업로드된 미디어 파일
├── manage.py            # Django 관리 명령어
├── requirements.txt     # Python 의존성
└── README.md           # 프로젝트 문서
```

## API 문서

관리자 계정으로 로그인 후 `/admin/` 에서 각 모델을 확인할 수 있습니다.

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.