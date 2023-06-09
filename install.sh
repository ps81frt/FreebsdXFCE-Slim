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
get https://github.com/gocobachi/slim-freebsd-dark-theme/archive/refs/heads/master.zip
unzip -d /usr/local/share/slim/themes/
cd /usr/local/share/slim/themes/
sudo vim /usr/local/etc/slim.conf 
#current_theme      default
#current_theme       slim-freebsd-dark-theme
startx
