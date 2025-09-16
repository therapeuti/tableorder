#!/bin/bash
# EC2 서버 초기 설정 스크립트

set -e

echo "=== EC2 서버 초기 설정 시작 ==="

# 시스템 업데이트
echo "시스템 업데이트 중..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Docker 설치
echo "Docker 설치 중..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker ubuntu
    rm get-docker.sh
fi

# Docker Compose 설치
echo "Docker Compose 설치 중..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Git 설치
echo "Git 설치 중..."
sudo apt-get install -y git curl

# 방화벽 설정
echo "방화벽 설정 중..."
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

# 프로젝트 디렉토리 생성
echo "프로젝트 디렉토리 생성 중..."
mkdir -p /home/ubuntu/tableorder
cd /home/ubuntu/tableorder

# 데이터 디렉토리 생성
mkdir -p data/db data/media
chmod -R 755 data

echo "=== EC2 서버 초기 설정 완료 ==="
echo "다음 단계:"
echo "1. GitHub Secrets에 다음 값들을 설정하세요:"
echo "   - EC2_HOST: $EC2_HOST"
echo "   - EC2_USERNAME: ubuntu"
echo "   - EC2_SSH_KEY: (SSH private key)"
echo "   - SECRET_KEY: (Django secret key)"
echo "2. GitHub에서 Actions를 실행하여 배포하세요."