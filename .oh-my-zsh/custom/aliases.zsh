######################################
# PACKAGE MANAGEMENT ALIASES
######################################

if [[ -f /etc/arch-release ]]; then
  # Arch
  alias u='lastupdate && sudo pacman -Syu && checkreboot'
  alias i='sudo pacman -S '
  alias f='pacman -Ss '
  alias r='sudo pacman -R '
  alias rr='sudo pacman -Rs '
  alias rrr='sudo pacman -Rns '
  alias c='sudo pacman -Sc'
  alias y='yay -S '
  alias p='paru'

elif [[ -f /etc/lsb-release ]]; then
  # Debian/Ubuntu
  alias u='lastupdate && sudo apt update && sudo apt upgrade && checkreboot'
  alias i='sudo apt install '
  alias f='apt search '
  alias r='sudo apt remove '
  alias rr='sudo apt purge '
  alias c='sudo apt autoremove && sudo apt clean'
  alias fd='fdfind'

else
  echo "Unsupported distribution or cannot detect distribution."
fi
