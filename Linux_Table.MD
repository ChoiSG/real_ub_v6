Original Authors: STNevans, Mailman, choi 

Updating for UB Lockdown v6 - 4/22/2019

| Method of Hiding | Method of fixing | Five Min Plan Fixes?  |
|----------|------------------------|---|
| ***Code re-running (Tasks)*** | | |
| .bashrc       | look at bashrc, remove bad lines. Overwrite with `clean_files/.bashrc` |  N |
| Cron | Uninstall cron, stop cron  | Y |
| Malicious Service Added | `systemctl list-unit-files` or `service --status-all`  | N  |
| Random processes running | `ps faux`, `pwdx pid` | N |
| ***Letting red team log in directly*** | | |
| Extra Users | remove the users  | N  |
| Pam Backdoor | Fix pam config? Set UsePam: No in sshd_config. Overwrite `/etc/pam.d/common-auth` with `clean_files/common-auth`  | N  |
| NoLogin | make sure `nologin`,`false` isn't a shell| N |
| ***Ways to connect without logging in*** | | |
| reverse shell | iptables | Y  |
| Service Specific Backdoors (headshot, web shell) | See (Service Specific)  | N |
| Watershell | `lsof \| grep -i raw`, `kill -9 pid` | N |
| ***This doesn't make sense?!***| | | 
| Rootkit | `lsmod`,`modinfo name`,`rmmod`,`nano /etc/modprobe.d/blacklist.conf`,`reboot`  | N |
| ***Privesc*** | | |
| Suid Binaries | `find / -perm /6000` | N |
| /etc/sudoers | Look at it, pretty much no NOPASSWD, no one other than root, %admin, %sudo/%wheel. Overwrite `/etc/sudoers` with `clean_files/sudoers`  | N | 

Service Specific Backdoors:

| Service | Method | How to fix  |
|----------|------------------------|----------|
| Web | webshell | grep for system/exec in /var/www. If the file seems susp, remove it. |
| Nginx | Headshot | `nginx -V` looks for modules. If the modules include `--add-module=../` and/or `--user=root`, that means nginx is headshot-backdoored. Backup all configuration files using `tar -czvf "/tmp/nginx_backup.tar.gz" /etc/nginx/ /usr/share/nginx/ /usr/lib/nginx/` and reinstall nginx. |
| MySql | Trickshot | `mysql -u root -p<password> -e"select * from mysql.func"` and do `strings /usr/lib/mysql/plugin/* \| grep sys_exec_deinit` If sys_exec_deinit exists, that file is trickshot plugin. To remove trickshot, `mysql -u root -p<password> -e"drop function <trickshot_function_name>` and then delete the plugin file (<trickshot>.so) | 
| SSH | Backdoored binary | Reinstall ssh |

Not sure where to put this:
Spy on any new processes:
https://raw.githubusercontent.com/brendangregg/perf-tools/master/execsnoop
