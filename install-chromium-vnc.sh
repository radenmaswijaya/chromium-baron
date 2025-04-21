#!/bin/bash

# Auto install Chromium Docker + VNC + noVNC (Ringan untuk VPS Kentang)
# Author: @raden (request dari user baron-ganteng)

set -e

echo "===> Update & Install tools dasar"
apt-get update -qq && apt-get install -y -qq curl ufw sudo ca-certificates gnupg lsb-release > /dev/null

echo "===> Setup firewall & open port"
ufw allow 3010
ufw allow 6901
ufw --force enable

echo "===> Install Docker (ringan & stabil)"
install_docker() {
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null
}

install_docker

echo "===> Tarik image Docker Chromium ringan (XFCE)"
docker pull accetto/ubuntu-vnc-xfce-chromium:latest

echo "===> Hapus container lama jika ada"
docker rm -f chromium > /dev/null 2>&1 || true

echo "===> Jalankan container dengan Chromium + noVNC"
docker run -d \
  --name chromium \
  -p 6901:6901 -p 3010:3010 \
  -e VNC_PW="BARON-GANTENG" \
  accetto/ubuntu-vnc-xfce-chromium:latest > /dev/null

echo "=================================================="
echo "Chromium + VNC + noVNC sudah aktif!"
echo "URL noVNC : http://$(curl -s ifconfig.me):6901"
echo "Username  : user"
echo "Password  : BARON-GANTENG"
echo "=================================================="
