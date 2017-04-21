#!/bin/bash
apt-get clean && apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends binutils p7zip-full usbutils file-roller ibus ibus-unikey nano geany net-tools ca-certificates apt-utils\
   expect apt-transport-https locales debconf-i18n; locale-gen; localedef -i en_US -f UTF-8 en_US.UTF-8;
echo "deb http://ftp.debian.org/debian/ jessie-backports  main" >> /etc/apt/sources.list;
echo "deb http://ftp.de.debian.org/debian jessie main contrib" >>  /etc/apt/sources.list;
dpkg --add-architecture i386;
apt-get update -y;
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ntp xfonts-intl-japanese xfonts-intl-chinese ttf-mscorefonts-installer wget curl lxde obmenu nemo \
   chromium  chromium-l10n libreoffice cups samba vsftpd okular libqt5gui5 tightvncserver gimp  sshfs nautilus-share vlc gwenview autocutsel pulseaudio \
   pavucontrol pulseaudio-utils vinagre alsa-utils libasound2 libasound2-plugins x11-xserver-utils supervisor openssh-server git;
mkdir -p /tmp/root;
cd /tmp/root;
#install flash for chromium
wget https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.127/flash_player_ppapi_linux.x86_64.tar.gz -O flash_player_ppapi_linux.x86_64.tar.gz;
tar -xzf flash_player_ppapi_linux.x86_64.tar.gz;
cp libpepflashplayer.so /usr/lib/chromium/plugins/libpepflashplayer.so;
flashso="/usr/lib/chromium/plugins/libpepflashplayer.so";
flashversion=`strings $flashso 2> /dev/null | grep LNX | cut -d " " -f 2 | sed -e "s/,/./g"`;
echo "CHROMIUM_FLAGS=\"$CHROMIUM_FLAGS --ppapi-flash-path=$flashso --ppapi-flash-version=$flashversion\"" > /etc/chromium.d/pepperflashplugin-nonfree;
#echo "deb http://ftp.de.debian.org/debian jessie main non-free" >>  /etc/apt/sources.list; apt-get update -y;
#install p7zip-rar
wget http://ftp.jp.debian.org/debian/pool/non-free/p/p7zip-rar/p7zip-rar_9.20.1~ds.1-3_amd64.deb -O p7zip-rar.deb
dpkg -i p7zip-rar.deb
#install user
USERNAME=user;
PASSUSER=public;
useradd -mb /home -s /bin/bash -c "Welcome user" -d /home/${USERNAME} $USERNAME;
   passwd -d user;
   echo ${USERNAME}:${PASSUSER} | chpasswd;
   usermod  -aG dialout,cdrom,audio,video,plugdev,lpadmin $USERNAME;
   mkdir /home/${USERNAME}/.vnc;
#config vnc
echo '#!/bin/bash
export XKL_XMODMAP_DISABLE=1

[ -x /etc/X11/Xsession ] && /etc/X11/Xsession
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources

# Fix to make GNOME work
xsetroot -solid grey -cursor_name left_ptr
autocutsel -fork
#vncconfig -iconic &

#lxterminal &
[[ "$DBUS_SESSION_BUS_ADDRESS" ]] || {
#        eval `dbus-launch --sh-syntax –exit-with-session`
        eval `dbus-launch --auto-syntax --exit-with-session openbox`
        echo "D-BUS per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
}
ibus-daemon -drx
/usr/bin/lxsession -s LXDE -e LXDE
#lxpanel --profile LXDE
#/usr/bin/startlxde &
disown' > /home/${USERNAME}/.vnc/xstartup;
chmod 755 /home/${USERNAME}/.vnc/xstartup;
echo khongpho02 | vncpasswd -f > /home/$USERNAME/.vnc/passwd;
chown -R $USERNAME:$USERNAME /home/$USERNAME/.vnc;
chmod 0600 /home/$USERNAME/.vnc/passwd
#install novnc
cd /opt; git clone https://github.com/novnc/noVNC.git && chmod 777 /opt/noVNC/utils
echo "[program:sshd]
command = /etc/init.d/ssh start
autostart=true
autorestart=true
[program:tightvncserver]
command = tightvncserver :1 -geometry 1366x768 -name linuxvnc -alwaysshared -depth 24 -dpi 100
autostart=true
user=$USERNAME
autorestart=true
[program:cups]
command = /etc/init.d/cups start
autostart=true
autorestart=true
[program:ntp]
command = /etc/init.d/ntp start
autostart=true
autorestart=true
[program:novnc]
command = /opt/noVNC/utils/launch.sh  --web /opt/noVNC --listen 5900 --vnc localhost:5901
user=$USERNAME
autostart=true
autorestart=true
" > /etc/supervisor/conf.d/user.conf
#install recomment
DEBIAN_FRONTEND=noninteractive apt-get install -y gvfs-backends xscreensaver obconf gvfs-fuse xfonts-base samba-vfs-modules \
   dosfstools ntfs-3g gdisk gksu bzip2 p7zip-full unzip xz-utils usbip nemo-fileroller cups-browsed usbmuxd rsync ssh-client pavumeter paprefs zip gvfs-bin chromium-inspector 
