Original Authors: STNevans, Mailman, choi 

Updating for UB Lockdown v6 - 4/22/2019

## Education 

[Week 8 - Blue Linux](https://docs.google.com/presentation/d/1UNsE8QchRp58e9dTAo7yMA0jDCYOymaIzrozuwG1HnU/edit#slide=id.g5268fc6fc7_3_0)

[Week 9 - Blue Windows](https://docs.google.com/presentation/d/1LgvtRh5rr1aWNXIIXtWbfsxiRT_X-4VjlzJR4Hjjqxc/edit#slide=id.g5475c5b054_1_0)

[Week 10 - Red Linux](https://docs.google.com/presentation/d/1btiu5W3Pas5blIGWEyvWtd1IK1nC2mdfkXqsdapO47w/edit#slide=id.g4528d5dd14_0_0)

[Week 11- Red Windows](https://docs.google.com/presentation/d/1yoQN8HrrloVjn1-G34Sn_XiK2AimB_TPJWGtZhnSwcQ/edit#slide=id.g55ea4928d1_0_16)

| Method of Hiding | Method of fixing | Are we ready?  |
|----------|------------------------|---|
| **Shimmed Binaries & Backdoored Services** | | | 
| Shimmed binaries | Reinstall `coreutils` `net-tools` `lsof` `procps` `build-essential` using package manager | N | 
| Backdoored Services | Reinstall services using package manager (ex. apt-get install --reinstall openssh-server) | Y/N | 
| **Code re-running (Tasks)** | | |
| Alias | `unalias -a` | N | 
| bash related files       | Overwrite `~/.bashrc` `/etc/bash.bashrc` `~/.profile` `~/.bash_logout` with config files in `/clean_files` |  N |
| Cron | Uninstall cron, stop cron  | Y |
| Malicious Service Added | `systemctl list-unit-files` or `service --status-all`  | N  |
| Random processes running | `ps faux`, `pwdx pid` | N |
| **Redteam Direct Access** | | |
| Extra Users | remove the users  | N  |
| Pam Backdoor | Fix pam config? Set UsePam: No in sshd_config. Overwrite `/etc/pam.d/common-auth` with `clean_files/common-auth`  | N  |
| NoLogin | make sure `nologin`,`false` isn't a shell| N |
| **Ways to connect without logging in** | | |
| reverse shell | iptables | Y  |
| Service Specific Backdoors (headshot, web shell) | See (Service Specific)  | N |
| Watershell | `lsof \| grep -i raw`, `kill -9 pid` | N |
| **This doesn't make sense?!**| | | 
| Rootkit | `lsmod`,`modinfo name`,`rmmod`,`nano /etc/modprobe.d/blacklist.conf`,`reboot`  | N |
| **Privesc** | | |
| Suid Binaries | `find / -perm /6000` | N |
| /etc/sudoers | Look at it, pretty much no NOPASSWD, no one other than root, %admin, %sudo/%wheel. Overwrite `/etc/sudoers` with `clean_files/sudoers`  | N | 



**Service Specific Backdoors**

| Service | Method | How to fix  |
|----------|------------------------|---------------|
| Web | webshell | grep for system/exec in /var/www. If the file seems susp, remove it. |
| Nginx | Headshot | `nginx -V` looks for modules. If the modules include `--add-module=../` and/or `--user=root`, that means nginx is headshot-backdoored. Backup all configuration files using `tar -czvf "/tmp/nginx_backup.tar.gz" /etc/nginx/ /usr/share/nginx/ /usr/lib/nginx/` and reinstall nginx. |
| MySql | Trickshot | `mysql -u root -p<password> -e"select * from mysql.func"` and do `strings /usr/lib/mysql/plugin/* \| grep sys_exec_deinit` If sys_exec_deinit exists, that file is trickshot plugin. To remove trickshot, `mysql -u root -p<password> -e"drop function <trickshot_function_name>` and then delete the plugin file (<trickshot>.so) |
| SSH | Backdoored binary | Reinstall ssh |

**MISC**

| Name | Method | How to fix |
|----------|------------------------|---------------|
| Campfire | Data Exfiltration binary | Check environment variable `ERROR_LOGGING` and check if there is a suspicious file `/var/log/systemd-<base64_encoded_string>`. Campfire uses these two to generate ip address and port. If you have found a binary, do a `strings <binary> \| grep "/usr/share/xtables-mul iptables-save"` to confirm it's campfire. | 
| Goofkit | Rootkit | No one have encountered goofkit in the wild. Thus we have no idea. | 
| Training Wheels Protocol | Check https://github.com/RITRedteam/TrainingWheelsProtocol | Soon(tm) | 


**Not sure where to put this**
Spy on any new processes:
https://raw.githubusercontent.com/brendangregg/perf-tools/master/execsnoop
