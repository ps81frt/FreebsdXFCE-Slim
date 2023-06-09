pkg install -y xorg xfce slim slim-theme nano vim htop wget git curl librewolf firefox drm-kmod
sysrc dbus_enable=YES
sysrc slim_enable=YES
sysrc moused_enable=YES
sysrc hald_enable=YES
sysrc sound_loud=YES
sysrc snd_hda_load=YES
sysrc kld_list=i915kms
pw groupmod video -m tech || pw groupmod wheel -m tech
echo "exec startxfce4" > /home/tech/.xinitrc
vim /boot/loader.conf
# Ahouter a la 1ère ligne 
kern.vty=vt
sed -i "1i kern.vty=vt" > /boot/loader.conf
wget https://github.com/gocobachi/slim-freebsd-dark-theme/archive/refs/heads/master.zip
unzip -d /usr/local/share/slim/themes/
cd /usr/local/share/slim/themes/
sudo vim /usr/local/etc/slim.conf 
#current_theme      default
#current_theme       slim-freebsd-dark-theme
startx

# ip fixe

more /etc/rc.conf
vim  /etc/rc.conf

ifconfig_em0="inet 192.168.2.20 netmask 255.255.255.0"
defaultrouter="192.168.2.254"

vim /etc/resolv.conf 
search sweet.home
nameserver 192.168.2.236
nameserver 192.168.2.237
nameserver 9.9.9.9
nameserver 1.1.1.1

service netif restart && service routing restart
netstat -4 -r -n

# Firewall pf

sudo sysrc pf_enable=YES
sudo sysrc pflog_enable=YES
sudo sysrc pf_rules=/usr/local/etc/pf.conf
sudo sysrc pf_rules=/usr/local/etc/pf.conf
sudo sysrc pflog_enable=YES
sudo sysrc pflog_logfile=/var/log/pflog


sudo vim /etc/pf.conf

vtnet0="vtnet0"
icmp_types = "{ echoreq unreach }"
table <bruteforce> persist
table <rfc6890> { 0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16          \
                  172.16.0.0/12 192.0.0.0/24 192.0.0.0/29 192.0.2.0/24 192.88.99.0/24    \
                  192.168.0.0/16 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24            \
                  240.0.0.0/4 255.255.255.255/32 }

set skip on lo0
scrub in all fragment reassemble max-mss 1440
# anti ip spoofing
antispoof quick for vtnet0
block all
# autoriser ssh
pass in proto tcp to port { 22 }
# limiter ne nombre de connextion a 15
keep state (max-src-conn 15, max-src-conn-rate 3/1, \ overload <bruteforce> flush global)
# 22 ssh 53 udp 80 http 123 tim ntp 443 https 110 pop 143 imap 993 web browsing
pass out proto { tcp udp } to port { 22 53 80 123 443 110 143 993 }
# autoriser le ping
#pass out inet proto icmp icmp-type { echoreq }
# bloquer le ping
# pass in inet proto icmp icmp-type { echoreq }
pass inet proto icmp icmp-type $icmp_types

# Chargement PF
sudo pfctl -f /etc/pf.conf

# Statistique PF

service pf check
sudo pfctl -si

# recharger pf
/etc/rc.d/pf reload
