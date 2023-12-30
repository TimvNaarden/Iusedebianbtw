#!/bin/bash

function install_discord()
{
    apt install curl
    curl -L "https://discord.com/api/download?platform=linux&format=deb" -o discord.deb
    apt install ./discord.deb
    rm discord.deb
}

function install_dolphin()
{
    apt install dolphin
}

function install_pavucontrol()
{
    apt install -y pavucontrol
}

function install_pulseaudio()
{
    apt install -y pulseaudio
}

function install_firefox()
{
    apt install wget tar
    wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
    tar xjf firefox.tar.bz2 -C /opt/
    ln -s /opt/firefox/firefox /usr/local/bin/firefox
    wget "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications
    rm firefox.tar.bz2 
}

function install_jetbrainsmononerdfont()
{
apt install -y wget unzip
mkdir ~/.fonts
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -o ~/.fonts/JetBrainsMono.zip
unzip ~/.fonts/JetBrainsMono.zip
}

function install_neovim()
{
    apt install -y wget tar make gcc cmake gettext unzip
    version="0.9.4"
    wget "https://github.com/neovim/neovim/archive/refs/tags/v$version.tar.gz" -o neovim.tar.gz
    tar -xf neovim.tar.gz
    cd neovim-$version
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    make install
    cd -
    rm -rf neovim-$version
}

function install_nvchad()
{
    apt install -y git
    git clone "https://github.com/NvChad/NvChad" ~/.config/nvim --depth 1
}

function install_st()
{
    apt install -y git make gcc build-essential libxft-dev libharfbuzz-dev libgd-dev
    git clone "https://github.com/sten-code/st" ~/.config/st
    cd ~/.config/st
    make install
    cd -
}

function install_chadwm()
{
    apt install -y git make gcc picom rofi feh acpi libimlib2
    git clone "https://github.com/timvnaarden/chadwm" --depth 1 ~/.config/chadwm
    cd ~/.config/chadwm/chadwm
    make install
    cd -

    echo "startx ~/.config/chadwm/scripts/run.sh" >> ~/.profile

    mkdir ~/Backgrounds
    mv ~/.config/chadwm/Windows.jpeg ~/Backgrounds/Windows.jpeg
  
}

function install_remmina()
{
    apt install -y remmina
}

function install_vlc()
{
    apt install -y vlc
}

function install_thunderbird()
{
    apt install -y thunderbird
}

function install_networkmanager()
{
    apt purge -y dhclient isc-dhcp-client isc-dhcp-common 
    apt install -y network-manager wpa_supplicant
    rm /etc/wpa_supplicant.conf
    echo """
        [Unit]
        Description=WPA supplicant
        After=dbus.service
        IgnoreOnIsolate=true

        [Service]
        Type=dbus
        BusName=fi.w1.wpa_supplicant1
        ExecStart=/sbin/wpa_supplicant -u -s -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlo1
        Restart=always
        ExecReload=/bin/kill -HUP $MAINPID
        Group=netdev
        RuntimeDirectory=wpa_supplicant
        RuntimeDirectoryMode=0750

        [Install]
        WantedBy=multi-user.target
        Alias=dbus-fi.w1.wpa_supplicant1.service
    """ >> /etc/wpa_supplicant.conf
}
function install_qbittorrent()
{
    apt install -y qbittorrent
}

function install_steam() 
{
    wget -O steam.deb "https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
    apt install -y ./steam.deb
    rm steam.deb
}

function install_spotify()
{
    apt install -y curl
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
    apt update
    apt install -y spotify-client
}

function update_sources() 
{
    rm /etc/apt/sources.list
    echo """
        # deb cdrom:[Debian GNU/Linux 12.2.0 _Bookworm_ - Official amd64 NETINST with firmware 20231007-10:28]/ bookworm main non-free-firmware

        deb http://debian.snt.utwente.nl/debian/ bookworm main non-free non-free-firmware contrib
        deb-src http://debian.snt.utwente.nl/debian/ bookworm main non-free non-free-firmware contrib

        deb http://security.debian.org/debian-security/ bookworm-security main non-free contrib
        deb-src http://security.debian.org/debian-security/ bookworm-security main non-free non-free-firmware contrib

        # bookworm-updates, to get updates before a point release is made;
        # see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
        deb http://debian.snt.utwente.nl/debian/ bookworm-updates main non-free non-free-firmware non-free-firmware contrib
        deb-src http://debian.snt.utwente.nl/debian/ bookworm-updates main non-free non-free-firmware non-free-firmware contrib

        # This system was installed using small removable media
        # (e.g., netinst, live or single CD). The matching "deb cdrom"
        # entries were disabled at the end of the installation process.
        # For information about how to configure apt package sources,
        # see the sources.list(5) manual.
    """ >> /etc/apt/sources.list
    apt update
}


function install_nvidia()
{
    apt install -y nvidia-driver
    openssl req -new -x509 -newkey rsa:2048 -keyout NVIDIA.priv -outform DER -out NVIDIA.der -nodes -days 36500 -subj "/CN=NVIDIA/"
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./NVIDIA.priv ./NVIDIA.der $(modinfo -n nvidia-current)
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./NVIDIA.priv ./NVIDIA.der $(modinfo -n nvidia-current-drm)
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./NVIDIA.priv ./NVIDIA.der $(modinfo -n nvidia-current-uvm)
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./NVIDIA.priv ./NVIDIA.der $(modinfo -n nvidia-current-peermem)
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./NVIDIA.priv ./NVIDIA.der $(modinfo -n nvidia-current-modeset)
    mokutil --import NVIDIA.der
    rm NVIDIA.priv NVIDIA.der
}

function install_ms-electron-365()
{
    apt install -y wget tar
    wget "https://github.com/agam778/MS-365-Electron/releases/download/v1.1.0/MS-365-Electron-v1.1.0-linux-amd64.deb" -o ms-electron-365.deb
    apt install -y ./ms-electron-365.deb
    rm ms-electron-365.deb
}

git clone "https://github.com/pedro-hs/checkbox.sh" checkbox

checkbox_options="
+Discord
+Dolphin
+Pavu Control
+Pulse Audio
+Firefox
+JetBrains Mono Nerd Font
+Neovim
+NvChad
+Suckless Terminal
+chadwm
+Remmina
+VLC
+Thunderbird
+Network Manager
+qBittorrent
+Steam
+Spotify"


source checkbox/checkbox.sh --multiple --index --options="$checkbox_options"
clear

options="
Discord
Dolphin
Pavu Control
Pulse Audio
Firefox
JetBrains Mono Nerd Font
Neovim
NvChad
Suckless Terminal
chadwm
Remmina
VLC
Thunderbird
Network Manager
qBittorrent
Steam
Spotify"

IFS=$' ' read -ra index_array <<< $(echo "$checkbox_output")
mapfile -t item_array <<< "$options"

for index in "${index_array[@]}"; do
  echo "Installing ${item_array[$index]}"
  case "${item_array[$index]}" in
    "Update Sources")           update_sources;;
    "Discord")                  install_discord;;
    "Dolphin")                  install_dolphin;;
    "Pavu Control")             install_pavucontrol;;
    "Pulse Audio")              install_pulseaudio;;
    "Firefox")                  install_firefox;;
    "JetBrains Mono Nerd Font") install_jetbrainsmononerdfont;;
    "Neovim")                   install_neovim;;
    "NvChad")                   install_nvchad;;
    "Suckless Terminal")        install_st;;
    "chadwm")                   install_chadwm;;
    "Remmina")                  install_remmina;;
    "VLC")                      install_vlc;;
    "Thunderbird")              install_thunderbird;;
    "Network Manager")          install_networkmanager;;
    "qBittorrent")              install_qbittorrent;;
    "Steam")                    install_steam;;
    "Spotify")                  install_spotify;;
    "Nvidia")                   install_nvidia;;
    "MS-365-Electron")          install_ms-electron-365;;
    *)
        echo "No installation found for ${item_array[$index]}"
        ;;
esac

apt autoremove -y
apt autoclean -y
apt update -y
done