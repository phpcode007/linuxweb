# turning system
ulimit -HSn 1024000 

sed -i '/nofile/d' /etc/security/limits.conf

echo -ne "
* soft nofile 1024000
* hard nofile 1024000
" >>/etc/security/limits.conf


sed -i '/DefaultLimitCORE/d' /etc/systemd/system.conf
sed -i '/DefaultLimitNOFILE/d' /etc/systemd/system.conf
sed -i '/DefaultLimitNPROC/d' /etc/systemd/system.conf

echo "DefaultLimitCORE=infinity" >> /etc/systemd/system.conf
echo "DefaultLimitNOFILE=1024002" >> /etc/systemd/system.conf
echo "DefaultLimitNPROC=1024003" >> /etc/systemd/system.conf


sed -i '/*/d' /etc/security/limits.d/20-nproc.conf 
echo "*       soft    nproc     1024001" >> /etc/security/limits.d/20-nproc.conf 


systemctl daemon-reexec


# /etc/sysctl.conf
cat >>/etc/sysctl.conf<<EOF
net.ipv4.netfilter.ip_conntrack_max = 131072
net.ipv4.tcp_max_tw_buckets = 200000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096        87380   4194304
net.ipv4.tcp_wmem = 4096        16384   4194304

net.ipv4.tcp_max_syn_backlog = 65536
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 32768

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_tw_recycle = 1
#net.ipv4.tcp_tw_len = 1
net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800

net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30

net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024    65000
EOF
