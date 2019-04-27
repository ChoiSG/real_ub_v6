#!/bin/bash

clear

printf "\n=========== Cron, SSH, nginx/apache2 ============\n"
service cron status 
service ssh status 
service sshd status

if [[ -n "$(command -v nginx)"  ]]; then 
    service nginx status 

elif [ -n "$(command -v apache2)" ]; then 
    service apache2 status 
fi 

printf "\n============== FIREWALL ===================\n"
iptables -L

printf "\n============== mangle: should be EMPTY ==============\n"
iptables --table mangle --list 

printf "\n============== my home ===================\n"
tree -a /media/floopy

printf "\n"
printf "============== Sudoers ===============\n"
cat /etc/sudoers 

printf "\n============= /etc/bash.bashrc ===============\n"
cat /etc/bash.bashrc | tail -5

printf "\n============= /etc/pam.d/common-auth ==========\n"
cat /etc/pam.d/common-auth

printf "\n============= /etc/ssh/sshd_config ESSENTIALS ONLY! Dont worrry=============\n"
cat /etc/ssh/sshd_config | grep Port
cat /etc/ssh/sshd_config | grep PermitRootLogin
cat /etc/ssh/sshd_config | grep PermitEmptyPasswords

printf "\n============= Watershell? =====================\n"
lsof | grep RAW

printf "\n============= All services ===================\n"
service --status-all

printf "\n============= /etc/passwd =============\n"
cat /etc/passwd 

printf "\n============= /etc/shadow =============\n"
cat /etc/shadow

printf "\n============= lsmod ===================\n"
lsmod
lsomd | grep goof
