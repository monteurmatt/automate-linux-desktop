#!/bin/bash

# Instalar o RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Instalar o driver da NVIDIA e CUDA (Descomentar caso placa nvidia)
#sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs -y
#sudo dnf install nvidia-vaapi-driver -y

# Corrigir os problemas de codec
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y
sudo dnf install amrnb amrwb faad2 flac gpac-libs lame libde265 libfc14audiodecoder mencoder x264 x265 ffmpegthumbnailer -y

# Instalar o GNOME Tweaks para configurar o botão de minimizar
sudo dnf install gnome-tweaks -y

# Instalar o Google Chrome (e remover o aviso de gerenciado pela organização) (Descomente se quiser baixar o chrome)
# sudo dnf install fedora-workstation-repositories -y
# sudo dnf config-manager --set-enabled google-chrome
# sudo dnf install google-chrome-stable -y
# sudo dnf remove fedora-chromium-config -y

# GIMP, Krita e Inkscape
sudo dnf install gimp krita inkscape -y

# Docker e Docker Compose 
sudo dnf install docker docker-compose -y
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Python3 e pip (pip geralmente vem com python3, mas garante que esteja instalado)
sudo dnf install python3 python3-pip -y

# Instalar utilitários para terminal e Btrfs Assistant
sudo dnf install ranger btop btrfs-assistant -y

# Instalar as fontes da Microsoft
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm -y

# Configura Super + D para minimizar janelas
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

# Configura Ctrl + Alt + T para abrir terminal (O terminal padrão do Fedora é o Ptyxis)
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ptyxis/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ptyxis/ name 'Abrir Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ptyxis/ command 'ptyxis'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ptyxis/ binding '<Control><Alt>t'

# Instalar ferramentas para jogos
sudo dnf install steam -y
flatpak install flathub com.vysp3r.ProtonPlus -y
flatpak install flathub net.davidotek.pupgui2 -y
flatpak install flathub com.steamgriddb.steam-rom-manager -y
flatpak install flathub com.steamgriddb.SGDBoop -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub dev.lizardbyte.app.Sunshine -y
flatpak install flathub net.lutris.Lutris -y


# Instalar aplicativos em flatpak
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub io.github.celluloid_player.Celluloid -y
flatpak install flathub org.gnome.Boxes -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub org.nickvision.tubeconverter -y
flatpak install flathub org.localsend.localsend_app -y
flatpak install flathub page.codeberg.libre_menu_editor.LibreMenuEditor -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub io.github.vikdevelop.SaveDesktop -y
flatpak install flathub com.rtosta.zapzap -y
flatpak install flathub org.cryptomator.Cryptomator -y
flatpak install flathub com.poweriso.PowerISO -y
flatpak install flathub com.brave.Browser -y
flatpak install flathub org.mozilla.Thunderbird -y
flatpak install flathub com.ulduzsoft.Birdtray -y
flatpak install flathub org.qbittorrent.qBittorrent -y


# Instalar e habilitar no ExtensionManager a bandeja de apps em 2 plano e barra inferior fixa
sudo dnf install gnome-shell-extension-appindicator gnome-shell-extension-dash-to-panel -y
gnome-extensions enable dash-to-panel@jderose9.github.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# Instalar e habilitar via extensions-cli o 'Start Overlay in Application View' (Super Key para menu de apps)
pip3 install --user gnome-extensions-cli
gext install 5040
gext enable start-overlay-in-application-view@hex_cz
gext install 779
gext enable clipboard-indicator@tudmotu.com


# Aplicativos para instalar manualmente após instalações dos apps acima: DaVinci Resolve
# Para ajustar problemas do DaVinci Resolve: https://github.com/monteurmatt/install-davinci-resolve
