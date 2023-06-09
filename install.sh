pkg install -y xorg xfce slim slim-theme nano vim htop wget git curl librewolf firefox
sysrc dbus_enable=YES
sysrc slim_enable=YES
sysrc moused_enable=YES
sysrc hald_enable=YES
sysrc sound_loud=YES
sysrc snd_hda_load=YES
echo "exec startxfce4" > ~/.xinitrc
startx
