#!/bin/bash

#--------------------------------FUNCTIONS--------------------------------------------

# Funktion zur Installation von Paketen mit yay
install_with_yay() {
    for pkg in "$@"; do
        yay -S --noconfirm "$pkg"
    done
}

# Funktion zum Klonen eines Git-Repositories
clone_repo() {
    local repo_url=$1
    local dest_dir=$2

    # Klone das Repository
    if [ ! -d "$dest_dir" ]; then
        git clone "$repo_url" "$dest_dir"
    else
        echo "Das Verzeichnis $dest_dir existiert bereits. Repository wurde nicht geklont."
    fi
}

necessary=(
    fakeroot
    stow
)

# Liste der Pakete
packages=(
    kitty
    waybar
    hyprland
    wofi
    hyprpaper
    swaync
    ttf-jetbrains-mono-nerd
    pipewire
    wireplumber
    xdg-desktop-portal-hyprland
    yazi
    qt5-wayland
    qt6-wayland
    playerctl
    hyprlock
    hypridle
    meson
    cmake
    gcc
    pkg-config
    wlogout
    pavucontrol
    obsidian
    discord
    visual-studio-code-bin
    google-chrome
    obs-studio
    spotify
    teams
    thunderbird
    steam
    make
    neovim
    luarocks
    ripgrep
    fd
    gvfs-smb
    blueman
    xdg-desktop-portal-gtk
    OpenTabletDriver
)

#--------------------Program start----------------------------------

# First Install yay
sudo pacman -Sy --noconfirm yay


install_with_yay "${necessary[@]}"


#--------------------Clone Dotfiles and stow them to .config--------

cd "$HOME/.dotfiles" || exit

for dir in */; do
    stow "$dir"
done

cd 

#---------------------Install oh my Zsh-------------------------------

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

#Change zsh to default shell -> before prohibited because of --unattended flag 
chsh -s $(which zsh)

#--------------------Make all Hyprland scripts executable
# Mache alle Skripte im Verzeichnis $HOME/.dotfiles/hypr/.config/hypr/scripts ausführbar

if [ -d "$HOME/.dotfiles/hypr/.config/hypr/scripts" ]; then
    chmod +x "$HOME/.dotfiles/hypr/.config/hypr/scripts"/*
else
    echo "Das Verzeichnis $HOME/.dotfiles/hypr/.config/hypr/scripts existiert nicht."
fi

cd

#-----------------------Install more packages---------------------------------------

install_with_yay "${packages[@]}"

#-----------------------Install ZSH Plugins-----------------------------------------

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting


#------------------------Reboot if wanted-------------------------------------------

read -p "Möchten Sie das System jetzt neu starten? (j/n): " answer
case ${answer:0:1} in
    j|J )
        sudo reboot
    ;;
    * )
        echo "Das System wurde nicht neu gestartet. Bitte starten Sie manuell neu, wenn erforderlich."
    ;;
esac



