#使用yum安装一些编辑器和依赖库
function inityum()
{
    yum install -y gcc gcc++ gcc-c++ cmake make libxml2 libxml2-devel openssl openssl-devel perl perl-devel autoconf \
        pcre pcre-devel perl-ExtUtils-Embed ncurses-devel bison rsync systemd-devel  python-devel python3-devel\
        vim-enhanced vim-minimal vim-common unzip libjpeg-devel libpng-devel freetype-devel ntpdate openssh-clients wget net-tools psmisc iptables-services
}

inityum