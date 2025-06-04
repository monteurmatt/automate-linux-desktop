#!/bin/bash


# Instalar o GNOME Tweaks para configurar o botão de minimizar
sudo apt install gnome-tweaks -y

# GIMP e Krita 
sudo apt install gimp krita inkscape -y

# Docker e Docker Compose 
sudo apt install docker docker-compose -y
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Python3 e pip (pip geralmente vem com python3, mas garante que esteja instalado)
sudo apt install python3 python3-pip -y

# Instalar utilitários para terminal
sudo apt install ranger speedtest-cli btop -y

# Intalar gestor de e-mails e torrents
sudo apt install qbittorrent thunderbird -y

echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
sudo apt update
sudo apt install ttf-mscorefonts-installer -y


# Instalar ferramentas para jogos
sudo apt install steam -y
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


# Instalar e habilitar via extensions-cli o 'clipboard-indicator'
pip3 install --user gnome-extensions-cli

# Adicionando pip ao PATH (se ainda não estiver lá)
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc

# Exporta temporariamente o PATH para este terminal atual
export PATH=$PATH:$HOME/.local/bin

# Instalar e ativar a extensão do clipboard
gext install 779
gext enable clipboard-indicator@tudmotu.com


# Configura Super + D para minimizar janelas
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
