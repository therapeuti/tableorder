# EC2 배포 가이드

이 가이드는 TableOrder Django 애플리케이션을 AWS EC2에 배포하는 방법을 설명합니다.

## 🚀 배포 아키텍처

- **서버**: AWS EC2 인스턴스
- **컨테이너**: Docker + Docker Compose
- **데이터베이스**: SQLite (볼륨 마운트)
- **웹서버**: Gunicorn
- **CI/CD**: GitHub Actions

## 📋 사전 요구사항

### EC2 인스턴스 설정
- **인스턴스 타입**: t3.micro (또는 그 이상)
- **OS**: Ubuntu 22.04 LTS
- **보안 그룹**: 22(SSH), 80(HTTP), 443(HTTPS) 포트 열기
- **키 페어**: SSH 접근용 키 페어 생성

### GitHub Secrets 설정
다음 secrets을 GitHub 저장소에 설정하세요:

```
EC2_HOST=your-ec2-public-ip
EC2_USERNAME=ubuntu
EC2_SSH_KEY=your-private-ssh-key-content
SECRET_KEY=your-django-secret-key
DOCKER_USERNAME=your-dockerhub-username
DOCKER_PASSWORD=your-dockerhub-password-or-token
```

## 🛠️ 배포 단계

### 1. EC2 서버 초기 설정

EC2 인스턴스에 SSH로 접속한 후:

```bash
# 설정 스크립트 다운로드 및 실행
curl -o setup-ec2.sh https://raw.githubusercontent.com/your-repo/tableorder/main/scripts/setup-ec2.sh
chmod +x setup-ec2.sh
./setup-ec2.sh
```

### 2. Docker Hub 설정

1. Docker Hub에서 새 리포지토리 생성: `tableorder`
2. GitHub Secrets에 Docker Hub 사용자명이 설정되어 있으면 자동으로 `{사용자명}/tableorder` 이미지를 사용합니다

### 3. GitHub Actions를 통한 자동 배포

1. 코드를 `main` 브랜치에 푸시
2. **Build and Push Docker Image** 워크플로우가 먼저 실행되어 이미지를 빌드하고 Docker Hub에 푸시
3. **Deploy to EC2** 워크플로우가 자동으로 실행되어 EC2에서 이미지를 풀하고 배포
4. 배포 완료 후 `http://your-ec2-ip`로 접속

### 3. 수동 배포 (선택사항)

EC2 서버에서 직접 배포하려면:

```bash
cd /home/ubuntu/tableorder
./scripts/manual-deploy.sh
```

## 🗄️ 데이터베이스 관리

### 관리자 계정 생성
```bash
docker-compose exec web python manage.py createsuperuser
```

### 마이그레이션 실행
```bash
docker-compose exec web python manage.py migrate
```

### 데이터베이스 백업
```bash
./scripts/backup.sh
```

### 백업 복원
```bash
./scripts/restore.sh /home/ubuntu/backups/tableorder_backup_YYYYMMDD_HHMMSS.tar.gz
```

## 📁 파일 구조

```
/home/ubuntu/tableorder/
├── data/                   # SQLite DB 및 미디어 파일 (볼륨 마운트)
│   ├── db/
│   │   └── db.sqlite3
│   └── media/
├── scripts/                # 배포 및 관리 스크립트
├── .env                    # 환경 변수
└── docker-compose.yml      # Docker 설정
```

## 🔧 트러블슈팅

### 애플리케이션 로그 확인
```bash
docker-compose logs -f web
```

### 컨테이너 상태 확인
```bash
docker-compose ps
```

### 컨테이너 재시작
```bash
docker-compose restart web
```

### 전체 재배포
```bash
docker-compose down
docker-compose up -d --build
```

## 📊 모니터링

### 헬스체크
```bash
curl -f http://localhost/admin/login/
```

### 시스템 리소스 확인
```bash
htop
df -h
```

## 🔒 보안 고려사항

1. **SSH 키 관리**: 프라이빗 키를 안전하게 보관
2. **환경변수**: SECRET_KEY를 강력하게 설정
3. **방화벽**: 필요한 포트만 열기
4. **정기 업데이트**: 시스템 및 Dependencies 업데이트
5. **백업**: 정기적인 데이터 백업 실행

## 📝 유지보수

### 정기 백업 설정 (Cron)
```bash
# 매일 새벽 2시에 백업 실행
0 2 * * * /home/ubuntu/tableorder/scripts/backup.sh
```

### 로그 로테이션
Docker 로그가 너무 커지지 않도록 설정:

```yaml
# docker-compose.yml에 추가
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

## 📞 지원

문제가 발생하면 다음을 확인하세요:
1. GitHub Actions 로그
2. Docker 컨테이너 로그
3. EC2 시스템 로그
4. 네트워크 연결 상태