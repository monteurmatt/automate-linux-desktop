#!/bin/bash

#-----------------------------------------------------

#Adiciona repositório packman, melhora a velocidade de download do zypper e atualiza.

# Carrega as variáveis de /etc/os-release (ID, VERSION_ID, etc.)
# Usando '.' para maior portabilidade POSIX em arquivos .sh
. /etc/os-release

echo "--- Configurando zypp para conexões mais rápidas ---"
sudo sed -i '/^#\?download.max_concurrent_connections/c\download.max_concurrent_connections = 10' /etc/zypp/zypp.conf
if ! grep -q "download.max_concurrent_connections" /etc/zypp/zypp.conf; then
    echo "download.max_concurrent_connections = 10" | sudo tee -a /etc/zypp/zypp.conf > /dev/null
fi

echo "--- Atualizando repositórios ---"
sudo zypper refresh -f # Força a atualização dos metadados

echo "--- Atualizando o sistema operacional base ---"
# Slowroll e Tumbleweed usam 'dup'. Leap usa 'update'.
if [ "$ID" = "opensuse-tumbleweed" ] || [ "$ID" = "opensuse-slowroll" ]; then
    sudo zypper dup --no-allow-vendor-change -y
elif [ "$ID" = "opensuse-leap" ]; then
    sudo zypper update -y
else
    echo "AVISO: ID do sistema ($ID) não reconhecido para atualização inicial. Tentando 'zypper dup' como padrão seguro."
    sudo zypper dup --no-allow-vendor-change -y 
fi

echo "--- Configurando o repositório Packman ---"
PACKMAN_REPO_URL=""
# Slowroll usa o repositório Packman do Tumbleweed
if [ "$ID" = "opensuse-tumbleweed" ] || [ "$ID" = "opensuse-slowroll" ]; then
    PACKMAN_REPO_URL="https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/"
elif [ "$ID" = "opensuse-leap" ]; then
    PACKMAN_REPO_URL="https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_${VERSION_ID}/"
else
    echo "AVISO: ID do sistema ($ID) não reconhecido para configuração automática do Packman. Adicione manualmente se necessário."
fi

if [ -n "$PACKMAN_REPO_URL" ]; then
    echo "Adicionando repositório Packman de: $PACKMAN_REPO_URL"
    sudo zypper rr packman 2>/dev/null || true 
    sudo zypper ar -cfp 90 "$PACKMAN_REPO_URL" packman
    
    echo "--- Atualizando metadados dos repositórios (incluindo Packman) e importando chaves ---"
    sudo zypper --gpg-auto-import-keys refresh -f
    
    echo "--- Realizando 'zypper dup' para permitir mudança de fornecedor para o Packman ---"
    sudo zypper dup --from packman --allow-vendor-change -y
else
    echo "ERRO: Não foi possível determinar a URL do Packman para o seu sistema ($ID - $VERSION_ID)."
    echo "Você precisará adicionar o repositório Packman manualmente e rodar 'sudo zypper dup --allow-vendor-change -y'."
fi

echo "--- Configuração do Packman e atualização do sistema concluídas ---"

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
sudo zypper remove -y gnome-chess gnome-mahjongg gnome-mines gnome-sudoku iagno lightsoff quadrapassel swell-foop xscreensaver transmission-gtk tigervnc eog xterm gimp


# Docker e Docker Compose 
sudo zypper install -y docker docker-compose 
sudo systemctl enable --now docker
sudo usermod -aG docker $USER


# Python3 e pip (pip geralmente vem com python3, mas garante que esteja instalado)
sudo zypper install -y python3 python3-pip 


# Instalar utilitários para terminal
sudo zypper install -y gnome-terminal ranger btop 


# Instalar ferramentas para jogos
flatpak install --user -y flathub com.valvesoftware.Steam; \
flatpak install --user -y flathub com.vysp3r.ProtonPlus; \
flatpak install --user -y flathub net.davidotek.pupgui2; \
flatpak install --user -y flathub com.steamgriddb.steam-rom-manager; \
flatpak install --user -y flathub com.steamgriddb.SGDBoop; \
flatpak install --user -y flathub com.usebottles.bottles; \
flatpak install --user -y flathub com.heroicgameslauncher.hgl; \
flatpak install --user -y flathub dev.lizardbyte.app.Sunshine; \
flatpak install --user -y flathub net.lutris.Lutris; \

# Instalar aplicativos em flatpak
flatpak install --user -y flathub com.discordapp.Discord; \
flatpak install --user -y flathub com.spotify.Client; \
flatpak install --user -y flathub com.obsproject.Studio; \
flatpak install --user -y flathub io.github.celluloid_player.Celluloid; \
flatpak install --user -y flathub org.gnome.Boxes; \
flatpak install --user -y flathub com.mattjakeman.ExtensionManager; \
flatpak install --user -y flathub com.github.tchx84.Flatseal; \
flatpak install --user -y flathub org.nickvision.tubeconverter; \
flatpak install --user -y flathub org.localsend.localsend_app; \
flatpak install --user -y flathub page.codeberg.libre_menu_editor.LibreMenuEditor; \
flatpak install --user -y flathub com.discordapp.Discord; \
flatpak install --user -y flathub com.visualstudio.code; \
flatpak install --user -y flathub io.github.vikdevelop.SaveDesktop; \
flatpak install --user -y flathub com.rtosta.zapzap; \
flatpak install --user -y flathub org.cryptomator.Cryptomator; \
flatpak install --user -y flathub com.poweriso.PowerISO; \
flatpak install --user -y flathub com.brave.Browser; \
flatpak install --user -y flathub org.mozilla.Thunderbird; \
flatpak install --user -y flathub com.ulduzsoft.Birdtray; \
flatpak install --user -y flathub org.qbittorrent.qBittorrent; \
flatpak install --user -y flathub org.gimp.GIMP; \
flatpak install --user -y flathub org.kde.krita; \
flatpak install --user -y flathub org.inkscape.Inkscape; \
flatpak install --user -y flathub org.gnome.gThumb



# Configura Super + D para minimizar janelas
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"


# Cria o atalho personalizado Super + T para abrir o GNOME Terminal
KEYBINDING_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$KEYBINDING_PATH']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEYBINDING_PATH name 'Abrir Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEYBINDING_PATH command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEYBINDING_PATH binding '<Super>t'



## Instalar pipx via zypper e gnome-extensions-cli via pipx
sudo zypper install -y python3-pipx 
pipx install gnome-extensions-cli
pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"


# Instalar extensões GNOME Shell
gnome-extensions-cli install 615 # AppIndicator
gnome-extensions-cli install 307 # Dash to Dock
#gnome-extensions-cli install 1160 # Dash to Panel --> substituido pela extensão acima 'dash-to-dock'
gnome-extensions-cli install 5040 # Start Overlay in Application View
gnome-extensions-cli install 779 # Clipboard Indicator
gnome-extensions-cli install 3193 # Blur My Shell

# Habilitar extensões GNOME Shell
gnome-extensions-cli enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions-cli enable dash-to-dock@micxgx.gmail.com
gnome-extensions-cli enable start-overlay-in-application-view@hex_cz
gnome-extensions-cli enable clipboard-indicator@tudmotu.com
gnome-extensions-cli enable blur-my-shell@aunetx
