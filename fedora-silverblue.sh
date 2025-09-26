#!/bin/bash

#-----------------------------------------------------

## Criar container do Fedora para usar o "dnf install"
toolbox create -y


## Resolve problemas de codecs [Funciona direto no sistema, mas não segue filosofia SilverBlue do Fedora..]
#rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#rpm-ostree install lame faad2 ffmpeg libde265 x264 x265 gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel


## Adiciona repositório e instala o Docker [Obs.: Não é necessário, pois SilverBlue contém podman por padrão]
sudo curl -L -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo
rpm-ostree install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


## Instala gnome-tweaks para ajustes do gnome
sudo rpm-ostree install gnome-tweaks

# Python3 e pip (pip geralmente vem com python3, mas garante que esteja instalado)
toolbox run sudo dnf install -y python3 python3-pip


# Instalar utilitários para terminal
toolbox run sudo dnf install -y ranger btop fastfetch


# Instalar ferramentas para jogos
flatpak install -y flathub com.valvesoftware.Steam;
flatpak install -y flathub com.vysp3r.ProtonPlus;
flatpak install -y flathub net.davidotek.pupgui2;
flatpak install -y flathub com.steamgriddb.steam-rom-manager;
flatpak install -y flathub com.steamgriddb.SGDBoop;
flatpak install -y flathub com.usebottles.bottles;
flatpak install -y flathub com.heroicgameslauncher.hgl;
flatpak install -y flathub dev.lizardbyte.app.Sunshine;
flatpak install -y flathub net.lutris.Lutris;

# Instalar aplicativos em flatpak
flatpak install -y flathub com.discordapp.Discord;
flatpak install -y flathub com.spotify.Client;
flatpak install -y flathub com.obsproject.Studio;
flatpak install -y flathub io.github.celluloid_player.Celluloid;
flatpak install -y flathub org.gnome.Boxes;
flatpak install -y flathub com.mattjakeman.ExtensionManager;
flatpak install -y flathub com.github.tchx84.Flatseal;
flatpak install -y flathub org.nickvision.tubeconverter;
flatpak install -y flathub org.localsend.localsend_app;
flatpak install -y flathub page.codeberg.libre_menu_editor.LibreMenuEditor;
flatpak install -y flathub com.visualstudio.code;
flatpak install -y flathub io.github.vikdevelop.SaveDesktop;
flatpak install -y flathub com.rtosta.zapzap;
flatpak install -y flathub org.cryptomator.Cryptomator;
flatpak install -y flathub com.poweriso.PowerISO;
flatpak install -y flathub com.brave.Browser;
flatpak install -y flathub org.mozilla.Thunderbird;
flatpak install -y flathub com.ulduzsoft.Birdtray;
flatpak install -y flathub org.qbittorrent.qBittorrent;
flatpak install -y flathub org.gimp.GIMP;
flatpak install -y flathub org.kde.krita;
flatpak install -y flathub org.inkscape.Inkscape;
flatpak install -y flathub org.gnome.gThumb;
flatpak install -y flathub org.libreoffice.LibreOffice;
flatpak install -y flathub org.onlyoffice.desktopeditors;



## Instalar pipx via dnf e gnome-extensions-cli via pipx
toolbox run sudo dnf install -y pipx
toolbox run pipx install gnome-extensions-cli
toolbox run pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"


# gnome-extensions-cli extensões GNOME Shell
toolbox run gnome-extensions-cli install 615 # AppIndicator
toolbox run gnome-extensions-cli install 307 # Dash to Dock
#toolbox run gnome-extensions-cli install 1160 # Dash to Panel --> substituido pela extensão acima 'dash-to-dock'
toolbox run gnome-extensions-cli install 5040 # Start Overlay in Application View
toolbox run gnome-extensions-cli install 779 # Clipboard Indicator
toolbox run gnome-extensions-cli install 3193 # Blur My Shell

# Habilitar extensões GNOME Shell
toolbox run gnome-extensions-cli enable appindicatorsupport@rgcjonas.gmail.com
toolbox run gnome-extensions-cli enable dash-to-dock@micxgx.gmail.com
toolbox run gnome-extensions-cli enable start-overlay-in-application-view@hex_cz
toolbox run gnome-extensions-cli enable clipboard-indicator@tudmotu.com
toolbox run gnome-extensions-cli enable blur-my-shell@aunetx


## **************** !!! NECESSÁRIO RODAR O COMANDO ABAIXO PARA ATIVAR O DOCKER DEPOIS DO SISTEMA REINICIADO COM DOCKER NA IMAGEM NOVA !!! ****************
#sudo systemctl enable --now docker
