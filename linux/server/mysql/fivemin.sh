#
# author: choi 
# Description: 5 min plan for mysql ubuntu 16.04 server 
#
# Note: UB Lockdown prohibits pre-staged scripts. Thus, all membmers 
# NEED TO print out all scripts and type them out during the #competition. 
#
# This is why this script will contain absolute barebones commands
#
# This is also why this script is not modular. This is one long script. For modular
# five minute plan, check out (https://github.com/ChoiSG/IRSEC_Crack_This/blob/master/debian/darbus)
#
#


# Five min plan breaks down to some parts. 
#
# 1. Init - Replacing shimmed binary, changing credentials, setting up HQ, adding backup users
# 2. Backup - grab configuration files, backup BIN, backup mysql related stuffs 
# 3. 
#
#
#
#


#!/bin/bash

# pre-staging 
echo "Change password of root."

apt-get install -y zsh 
chsh -s /bin/zsh root 

################## 1. Init  #################

# Take care of shimmed binaries
apt-get install -y --reinstall coreutils net-tools lsof procps build-essential passwd

# Create c2
cc='/media/floopy'
mkdir $cc $cc/old_conf $cc/artifacts $cc/bin

# change pass
read passwd
getUSERS | xargs -d'\n' -I {} sh -c "echo {}:$passwd | chpasswd"

getUSERS() {
    while IFS=: read a b c
    do
        if [ ! "$b" == "!" ] && [ ! "$b" == "*" ]; then 
            echo "$a"
        fi
    done < /etc/shadow
}

# Install some tools 
apt-get install -y --reinstall wget curl vim tree 

# Add some backup users 
useradd campfire
echo -e "Wkwkdaus!\nWkwkdaus!" | passwd campfire
usermod -aG sudo campfire 

useradd headshot
echo -e "xkdtndbr!\nxkdtndbr!" | passwd headshot
usermod -aG sudo headshot 


################### 2. Backup ########################
# backup binaries 
cp /bin/* $cc/bin/
cp /usr/bin/* $cc/bin/

#wget -q https://busybox.net/downloads/binaries/1.30.0-i686/busybox -O $cc/bin/busybox
#chmod +x $cc/bin/busybox

# backup configs
cp ~/.* $cc/old_conf
cp /etc/ssh/sshd_config /etc/sudoers /etc/pam.d/common-auth $cc/old_conf

# Backup mysql - need more research 

################# 3. Secure #######################

cp ./.vimrc ~/.vimrc
cp ./sshd_config /etc/ssh/sshd_config 
cp ./common-auth /etc/pam.d/common-auth 
