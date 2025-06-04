#!/bin/bash

#-----------------------------------------------------

#Instalando repositório adicional packman
OS_RELEASE_VER=$(grep VERSION_ID /etc/os-release | cut -d'=' -f2 | tr -d '"')

sudo sed -i '/^#\?download.max_concurrent_connections/c\download.max_concurrent_connections = 10' /etc/zypp/zypp.conf
if ! grep -q "download.max_concurrent_connections" /etc/zypp/zypp.conf; then
    echo "download.max_concurrent_connections = 10" | sudo tee -a /etc/zypp/zypp.conf > /dev/null
fi
sudo zypper refresh
if [ "$OS_RELEASE_VER" == "tumbleweed" ]; then
    sudo zypper dup --no-allow-vendor-change -y
else
    sudo zypper update -y
fi
PACKMAN_REPO_URL=""
if [ "$OS_RELEASE_VER" == "tumbleweed" ]; then
    PACKMAN_REPO_URL="https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/"
elif [[ "$OS_RELEASE_VER" =~ ^15 ]]; then # Para openSUSE Leap 15.x
    PACKMAN_REPO_URL="https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_${OS_RELEASE_VER}/"
else
    log_message "Versão do openSUSE não detectada para Packman. Adicione manualmente se necessário."
fi

if [ -n "$PACKMAN_REPO_URL" ]; then
    sudo zypper ar -cfp 90 "$PACKMAN_REPO_URL" packman
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper dup --allow-vendor-change -y
else
    log_message "Não foi possível adicionar o repositório Packman automaticamente para sua versão do openSUSE."
fi

#-----------------------------------------------------


#-----------------------------------------------------
#Diminuir Swappiness 
SWAPPINESS_VALUE=1
CONF_FILE="/etc/sysctl.d/99-swappiness.conf"

#Remover entradas anteriores para evitar duplicação
sudo sed -i '/^vm.swappiness=/d' /etc/sysctl.conf
sudo rm -f "$CONF_FILE"

# Criando um novo arquivo de configuração para o swappiness
echo "vm.swappiness = $SWAPPINESS_VALUE" | sudo tee "$CONF_FILE" > /dev/null
sudo sysctl -p "$CONF_FILE"
#-----------------------------------------------------


#Instalar Codecs
sudo zypper install -y opi
opi codecs -y


#Instalar e Configurar Flatpak
sudo zypper install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


#Instalar Fontes da Microsoft
sudo zypper install -y fetchmsttfonts


#Resolver problemas de áudio em hardwares mais novos ou específicos
sudo zypper install -y sof-firmware


#Remover mini-games e apps indesejados
sudo zypper remove -y gnome-chess gnome-mahjongg gnome-mines gnome-sudoku iagno lightsoff quadrapassel swell-foop xscreensaver transmission-gtk tigervnc eog xterm


# Docker e Docker Compose 
sudo zypper install -y docker docker-compose 
sudo systemctl enable --now docker
sudo usermod -aG docker $USER


# Python3 e pip (pip geralmente vem com python3, mas garante que esteja instalado)
sudo zypper install -y python3 python3-pip 


# Instalar utilitários para terminal
sudo zypper install -y ranger btop 


# Instalar ferramentas para jogos
sudo flatpak install -y flathub com.valvesoftware.Steam; \
sudo flatpak install -y flathub com.vysp3r.ProtonPlus; \
sudo flatpak install -y flathub net.davidotek.pupgui2; \
sudo flatpak install -y flathub com.steamgriddb.steam-rom-manager; \
sudo flatpak install -y flathub com.steamgriddb.SGDBoop; \
sudo flatpak install -y flathub com.usebottles.bottles; \
sudo flatpak install -y flathub com.heroicgameslauncher.hgl; \
sudo flatpak install -y flathub dev.lizardbyte.app.Sunshine; \ 
sudo flatpak install -y flathub net.lutris.Lutris;


# Instalar aplicativos em flatpak
sudo flatpak install -y flathub com.discordapp.Discord; \
sudo flatpak install -y flathub com.spotify.Client; \
sudo flatpak install -y flathub com.obsproject.Studio; \
sudo flatpak install -y flathub io.github.celluloid_player.Celluloid; \
sudo flatpak install -y flathub org.gnome.Boxes; \
sudo flatpak install -y flathub com.mattjakeman.ExtensionManager; \
sudo flatpak install -y flathub com.github.tchx84.Flatseal; \
sudo flatpak install -y flathub org.nickvision.tubeconverter; \
sudo flatpak install -y flathub org.localsend.localsend_app; \
sudo flatpak install -y flathub page.codeberg.libre_menu_editor.LibreMenuEditor; \
sudo flatpak install -y flathub com.discordapp.Discord; \
sudo flatpak install -y flathub com.visualstudio.code; \
sudo flatpak install -y flathub io.github.vikdevelop.SaveDesktop; \
sudo flatpak install -y flathub com.rtosta.zapzap; \
sudo flatpak install -y flathub org.cryptomator.Cryptomator; \
sudo flatpak install -y flathub com.poweriso.PowerISO; \
sudo flatpak install -y flathub com.brave.Browser; \
sudo flatpak install -y flathub org.mozilla.Thunderbird; \
sudo flatpak install -y flathub com.ulduzsoft.Birdtray; \
sudo flatpak install -y flathub org.qbittorrent.qBittorrent; \
sudo flatpak install -y flathub org.gnome.gedit; \
sudo flatpak install -y flathub org.gimp.GIMP; \
sudo flatpak install -y flathub org.kde.krita; \ 
sudo flatpak install -y flathub org.inkscape.Inkscape; \
sudo flatpak install -y flathub org.gnome.gThumb;



# Configura Super + D para minimizar janelas
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"


# Cria o atalho personalizado Ctrl+Alt+T para abrir o GNOME Terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gnome-terminal/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gnome-terminal/ name 'Abrir Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gnome-terminal/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gnome-terminal/ binding '<Control><Alt>t'



#Instalar pipx para baixar gnome-extensions-cli para habilitar o gext
pip3 install --user pipx
~/.local/bin/pipx ensurepath
source ~/.bashrc
pipx install gnome-extensions-cli
echo 'alias gext="gnome-extensions-cli"' >> ~/.bashrc
source ~/.bashrc


# Instalar extensões GNOME Shell
gext install 615 # AppIndicator
gext install 307 # Dash to Dock
#gext install 1160 # Dash to Panel --> substituido pela extensão acima 'dash-to-dock'
gext install 5040 # Start Overlay in Application View
gext install 779 # Clipboard Indicator
gext install 3193 # Blur My Shell

# Habilitar extensões GNOME Shell
gext enable appindicatorsupport@rgcjonas.gmail.com
gext enable dash-to-dock@micxgx.gmail.com
gext enable start-overlay-in-application-view@hex_cz
gext enable clipboard-indicator@tudmotu.com
gext enable blur-my-shell@aunetx
