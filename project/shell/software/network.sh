# welcome
cat << EOF
+--------------------------------------------------------------+
|         === Centos 系统初始化 ===                |
+--------------------------------------------------------------+
EOF


# disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0
echo "selinux is disabled,you must reboot!"

# vim
sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
cat >/root/.vimrc<<EOF
syntax on
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
EOF


# init_ssh
sed -i '/GSSAPI/ {s/yes/no/g};/UseDNS/ {s/.*/UseDNS no/};/^SyslogFacility/ {s/AUTHPRIV/local5/g}' /etc/ssh/sshd_config 
sed -i '/StrictHostKeyChecking/ {s/.*/StrictHostKeyChecking no/}' /etc/ssh/ssh_config
echo "Configured SSH initialization!"

# chkser
# tunoff services

systemctl stop postfix.service
systemctl disable postfix.service

# iptable
systemctl stop firewalld.service
systemctl disable firewalld.service

systemctl disable iptables.service


# set ntpdate
# crontab
crontab -l >> /tmp/crontab2.tmp
echo '15 1 * * * /usr/sbin/ntpdate time6.aliyun.com;/usr/sbin/hwclock -w > /dev/null 2>&1' >> /tmp/crontab2.tmp
crontab /tmp/crontab2.tmp
rm /tmp/crontab2.tmp

echo -e "\033[32;49;1mInitialization complete"
echo -en "\033[39;49;0m"
