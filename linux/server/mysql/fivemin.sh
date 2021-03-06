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
# [LATER] tags are to be used "later", since the infrastructure will be 
# extremely slow. 


# Five min plan breaks down to some parts. 
#
# 1. Init - Replacing shimmed binary, changing credentials, setting up HQ, adding backup users
# 2. Backup - grab configuration files, backup BIN, backup mysql related stuffs 
# 3. Secure - Disable cron, reinstalling ssh, overwriting sudoers, sshd_config, pam, revhunter
# 4. Firewall - iptables rules 
#


#!/bin/bash
getUSERS() {
    while IFS=: read a b c
    do
        if [ ! "$b" == "!" ] && [ ! "$b" == "*" ]; then 
            echo "$a"
        fi
    done < /etc/shadow
}



# pre-staging 
echo "Change password of root."

apt-get -qq install -y --reinstall zsh 
chsh -s /bin/zsh root 

echo "Restart the shell or re-ssh into the server"

################## 1. Init  #################

# Take care of shimmed binaries
apt-get -qq install -y --reinstall coreutils net-tools lsof procps passwd

# apt-get -qq install -y --reinstall build-essentials 

# Create c2
cc='/media/floopy'
mkdir $cc $cc/old_conf $cc/artifacts $cc/bin

# change pass
echo -e "Type your new password: "
read passwd
getUSERS | xargs -d'\n' -I {} sh -c "echo {}:$passwd | chpasswd"

# Install some tools 
apt-get -qq install -y --reinstall wget curl vim tree 

# Add some backup users 
useradd campfire
echo -e "Wkwkdaus!\nWkwkdaus!" | passwd campfire
usermod -aG sudo campfire 

useradd headshot
echo -e "xkdtndbr!\nxkdtndbr!" | passwd headshot
usermod -aG sudo headshot 


################### 2. Backup ########################
# [LATER] backup binaries 
#cp /bin/* $cc/bin/
#cp /usr/bin/* $cc/bin/

# [LATER] download busybox
#wget -q https://busybox.net/downloads/binaries/1.30.0-i686/busybox -O $cc/bin/busybox
#chmod +x $cc/bin/busybox

# [LATER] Reinstall ssh  
#apt-get -qq purge -y openssh-server
#apt-get -qq install -y openssh-server

# backup configs
cp -r ~/.* $cc/old_conf
cp /etc/ssh/sshd_config /etc/sudoers /etc/pam.d/common-auth /etc/bash.bashrc $cc/old_conf

# Backup mysql - need more research 

################# 3. Secure #######################

unalias -a 

cp ./.vimrc ~/.vimrc
cp ./sudoers /etc/sudoers
chmod 400 /etc/sudoers
cp ./sshd_config /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config
cp ./common-auth /etc/pam.d/common-auth


# Disable cron - Pick one! 
service cron stop 

# Rev hunter 
revhunter(){
    rev='if [ "$(tty)" == "not a tty" ]; then kill -9 $PPID; fi'
    echo $rev > /bin/rev
    chmod 755 /bin/rev
    echo "export PROMPT_COMMAND='/bin/rev'" >> /etc/bash.bashrc
}

############ 4. Firewall #############

echo "check the firewall.sh"
