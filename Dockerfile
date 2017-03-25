FROM debian:jessie
RUN bash -c 'echo "deb http://ftp.debian.org/debian/ jessie-backports  main" >> /etc/apt/sources.list; \
   localedef -i en_US -f UTF-8 en_US.UTF-8; \
   dpkg --add-architecture i386;\
   apt-get update -y;\
   apt-get install -y --no-install-recommends wget curl lxde nemo chromium libreoffice okular libqt5gui5 tightvncserver gimp  sshfs \
   nautilus-share vlc gwenview autocutsel pulseaudio pavucontrol pulseaudio-utils vinagre alsa-utils libasound2 libasound2-plugins \
   x11-xserver-utils supervisor openssh-server git;\
   #pepperflashplugin-nonfree;\
   mkdir -p /tmp/root;\
   cd /tmp/root;\
   wget https://fpdownload.adobe.com/pub/flashplayer/pdc/25.0.0.127/flash_player_ppapi_linux.x86_64.tar.gz -O flash_player_ppapi_linux.x86_64.tar.gz;\
   tar -xzf flash_player_ppapi_linux.x86_64.tar.gz;\
   cp libpepflashplayer.so /usr/lib/chromium/plugins/libpepflashplayer.so';\
   flashso="/usr/lib/chromium/plugins/libpepflashplayer.so";\
   flashversion=`strings $flashso 2> /dev/null | grep LNX | cut -d '\ \' -f 2 | sed -e "s/,/./g"`;\
   echo "CHROMIUM_FLAGS=\"$CHROMIUM_FLAGS --ppapi-flash-path=$flashso --ppapi-flash-version=$flashversion\"" > /etc/chromium.d/pepperflashplugin-nonfree;
ENV USERNAME=user
RUN bash -c 'useradd -mb /home -s /bin/bash -c "Welcome user" -d /home/${USERNAME} $USERNAME;\
	 passwd -d user;\
   echo ${USERNAME}:$2 | chpasswd;\
   usermod  -aG dialout $USERNAME;'
