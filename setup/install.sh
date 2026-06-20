#!/usr/bin/env bash
set -euo pipefail

RHP_VERSION="1.0.0"

# ──────────────────────────────────────────────
# Colors and helpers
# ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
header(){ echo -e "\n${CYAN}━━━ $* ━━━${NC}\n"; }

confirm() {
  local prompt="$1"
  local reply
  while true; do
    read -r -p "${prompt} [y/N] " reply
    case "$reply" in
      [yY]|[yY][eE][sS]) return 0 ;;
      [nN]|[nN][oO]|"")  return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

# ──────────────────────────────────────────────
# Step 0: Auto-detect repo root
# ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CONFIG_SRC="$REPO_ROOT/.config"
BIN_SRC="$REPO_ROOT/.local/bin"
SETUP_DIR="$REPO_ROOT/setup"
REQUIRED_PACKAGES_FILE="$SETUP_DIR/packages.required"
OPTIONAL_PACKAGES_FILE="$SETUP_DIR/packages.optional"

header "RHP-Config Installer v$RHP_VERSION"
echo "  Repo: $REPO_ROOT"
echo ""

# ──────────────────────────────────────────────
# Step 1: Environment checks
# ──────────────────────────────────────────────
header "Environment Check"

if [ ! -f /etc/arch-release ]; then
  error "This installer is designed for Arch Linux only."
  exit 1
fi
info "Arch Linux detected."

if [ "$(id -u)" -eq 0 ]; then
  error "Do not run this script as root. Run as a normal user with sudo access."
  exit 1
fi
info "Running as $(whoami)."

if ! command -v sudo &>/dev/null; then
  error "sudo is required but not installed."
  exit 1
fi

if ! sudo -n true 2>/dev/null; then
  if confirm "Sudo access is needed. Continue?"; then
    sudo -v
  else
    error "Sudo access required. Aborting."
    exit 1
  fi
fi
info "Sudo access confirmed."

if ! command -v git &>/dev/null; then
  warn "git not found. Installing..."
  sudo pacman -S --noconfirm git
fi
info "git is available."

# ──────────────────────────────────────────────
# Step 2: Parse required packages
# ──────────────────────────────────────────────
header "Package Parsing"

parse_packages() {
  local file="$1"
  local -n off_ref="$2"
  local -n aur_ref="$3"
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="${line## }"
    line="${line%% }"
    [ -z "$line" ] && continue
    if [[ "$line" == *-git ]] || [[ "$line" == *-bin ]]; then
      aur_ref+=("$line")
    else
      off_ref+=("$line")
    fi
  done < "$file"
}

OFFICIAL_PKGS=()
AUR_PKGS=()

if [ -f "$REQUIRED_PACKAGES_FILE" ]; then
  parse_packages "$REQUIRED_PACKAGES_FILE" OFFICIAL_PKGS AUR_PKGS
  info "Found ${#OFFICIAL_PKGS[@]} official and ${#AUR_PKGS[@]} AUR required packages."
else
  warn "No required packages file found at $REQUIRED_PACKAGES_FILE. Skipping package installation."
fi

# ──────────────────────────────────────────────
# Step 2b: Optional packages
# ──────────────────────────────────────────────
if [ -f "$OPTIONAL_PACKAGES_FILE" ]; then
  header "Optional Packages"

  OPT_OFFICIAL=()
  OPT_AUR=()
  parse_packages "$OPTIONAL_PACKAGES_FILE" OPT_OFFICIAL OPT_AUR

  if [ ${#OPT_OFFICIAL[@]} -gt 0 ] || [ ${#OPT_AUR[@]} -gt 0 ]; then
    echo "The following optional packages are available:"
    [ ${#OPT_OFFICIAL[@]} -gt 0 ] && echo "  Official: ${OPT_OFFICIAL[*]}"
    [ ${#OPT_AUR[@]} -gt 0 ] && echo "  AUR:      ${OPT_AUR[*]}"

    if confirm "Install optional packages?"; then
      OFFICIAL_PKGS+=("${OPT_OFFICIAL[@]}")
      AUR_PKGS+=("${OPT_AUR[@]}")
      info "Total to install: ${#OFFICIAL_PKGS[@]} official, ${#AUR_PKGS[@]} AUR."
    fi
  fi
fi

# ──────────────────────────────────────────────
# Step 3: AUR helper setup
# ──────────────────────────────────────────────
header "AUR Helper Setup"

AUR_HELPER=""

if [ ${#AUR_PKGS[@]} -gt 0 ]; then
  if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
    info "yay detected."
  elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
    info "paru detected."
  else
    warn "No AUR helper found."
    if confirm "Install yay (recommended AUR helper)?"; then
      if ! pacman -Qg base-devel &>/dev/null; then
        info "Installing base-devel..."
        sudo pacman -S --noconfirm base-devel
      fi
      [ -d /tmp/yay-bin ] && rm -rf /tmp/yay-bin
      git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
      (cd /tmp/yay-bin && makepkg -si --noconfirm)
      AUR_HELPER="yay"
      info "yay installed."
    else
      warn "Skipping AUR packages. You will need to install them manually."
    fi
  fi
fi

# ──────────────────────────────────────────────
# Step 4: Install packages
# ──────────────────────────────────────────────
install_official() {
  info "Installing official packages..."
  sudo pacman -S --needed "${OFFICIAL_PKGS[@]}"
}

install_aur() {
  [ -z "$AUR_HELPER" ] && return
  if [ ${#AUR_PKGS[@]} -gt 0 ]; then
    info "Installing AUR packages with $AUR_HELPER..."
    "$AUR_HELPER" -S --needed "${AUR_PKGS[@]}"
  fi
}

if [ ${#OFFICIAL_PKGS[@]} -gt 0 ] || [ ${#AUR_PKGS[@]} -gt 0 ]; then
  header "Package Installation"
  info "The following packages will be installed:"
  [ ${#OFFICIAL_PKGS[@]} -gt 0 ] && echo "  Official: ${OFFICIAL_PKGS[*]}"
  [ ${#AUR_PKGS[@]} -gt 0 ] && echo "  AUR:      ${AUR_PKGS[*]}"

  if confirm "Proceed with package installation?"; then
    [ ${#OFFICIAL_PKGS[@]} -gt 0 ] && install_official
    [ ${#AUR_PKGS[@]} -gt 0 ] && install_aur
    info "Package installation complete."
  else
    warn "Skipping package installation."
  fi
fi

# ──────────────────────────────────────────────
# Step 5: Backup existing configs
# ──────────────────────────────────────────────
header "Backup"

BACKUP_DIR="$HOME/.config/rhp-backup-$(date +%Y%m%d_%H%M%S)"
declare -a COLLISION_DIRS=()

for dir in "$CONFIG_SRC"/*/; do
  dirname="$(basename "$dir")"
  [ -e "$HOME/.config/$dirname" ] && COLLISION_DIRS+=("$dirname")
done

for item in "$BIN_SRC"/*; do
  basename_item="$(basename "$item")"
  if [ -e "$HOME/.local/bin/$basename_item" ] && [[ ! " ${COLLISION_DIRS[*]} " =~ " $basename_item " ]]; then
    COLLISION_DIRS+=("$basename_item")
  fi
done

if [ ${#COLLISION_DIRS[@]} -gt 0 ]; then
  info "Existing configs that will be backed up:"
  for d in "${COLLISION_DIRS[@]}"; do
    echo "  ~/.config/$d"
  done

  if confirm "Back up these configs and proceed?"; then
    mkdir -p "$BACKUP_DIR"
    for d in "${COLLISION_DIRS[@]}"; do
      if [ -e "$HOME/.config/$d" ]; then
        cp -a "$HOME/.config/$d" "$BACKUP_DIR/"
        info "Backed up ~/.config/$d"
      fi
    done
    # Back up bin files
    for item in "$BIN_SRC"/*; do
      bn="$(basename "$item")"
      [ -e "$HOME/.local/bin/$bn" ] && cp -a "$HOME/.local/bin/$bn" "$BACKUP_DIR/"
    done
    info "Backup saved to $BACKUP_DIR"
  else
    warn "Skipping backup."
  fi
else
  info "No existing configs to back up."
fi

# ──────────────────────────────────────────────
# Step 6: Deploy symlinks
# ──────────────────────────────────────────────
header "Deploy Symlinks"

deploy_symlinks() {
  info "Creating ~/.config/ symlinks..."
  mkdir -p "$HOME/.config"
  for dir in "$CONFIG_SRC"/*/; do
    dirname="$(basename "$dir")"
    target="$HOME/.config/$dirname"
    if [ -L "$target" ]; then
      rm -f "$target"
    elif [ -e "$target" ]; then
      rm -rf "$target"
    fi
    ln -sfn "$dir" "$target"
    info "  ~/.config/$dirname -> $dir"
  done

  info "Creating ~/.local/bin symlinks..."
  mkdir -p "$HOME/.local/bin"
  for item in "$BIN_SRC"/*; do
    bn="$(basename "$item")"
    target="$HOME/.local/bin/$bn"
    [ -L "$target" ] && rm -f "$target"
    ln -sfn "$item" "$target"
    info "  ~/.local/bin/$bn -> $item"
  done
}

if confirm "Deploy symlinks from repo to ~/.config/ and ~/.local/bin/?"; then
  deploy_symlinks
  info "Symlinks created."
else
  warn "Skipping symlink deployment."
fi

# ──────────────────────────────────────────────
# Step 7: Post-install
# ──────────────────────────────────────────────
header "Post-Install Setup"

# ZDOTDIR
ZDOTDIR_SET=false
ZSHENV="/etc/zsh/zshenv"
if [ -f "$ZSHENV" ] && grep -q "ZDOTDIR" "$ZSHENV" 2>/dev/null; then
  info "ZDOTDIR already configured in $ZSHENV"
  ZDOTDIR_SET=true
elif [ -f "$HOME/.zshenv" ] && grep -q "ZDOTDIR" "$HOME/.zshenv" 2>/dev/null; then
  info "ZDOTDIR already configured in ~/.zshenv"
  ZDOTDIR_SET=true
else
  if confirm "Set ZDOTDIR=$HOME/.config/zsh in ~/.zshenv?"; then
    echo 'export ZDOTDIR="$HOME/.config/zsh"' >> "$HOME/.zshenv"
    info "Added ZDOTDIR to ~/.zshenv"
    ZDOTDIR_SET=true
  fi
fi

# oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  info "oh-my-zsh already installed."
else
  if confirm "Install oh-my-zsh?"; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
    info "oh-my-zsh installed."
  fi
fi

# ~/.gitconfig
if [ -f "$HOME/.gitconfig" ]; then
  info "~/.gitconfig already exists."
else
  if confirm "Create a basic ~/.gitconfig?"; then
    read -r -p "  Git user name: " git_name
    read -r -p "  Git email: " git_email
    cat > "$HOME/.gitconfig" <<-EOF
[user]
	name = $git_name
	email = $git_email
[core]
	editor = nvim
EOF
    info "~/.gitconfig created."
  fi
fi

# Enable systemd user services
if confirm "Enable Hyprland systemd user services (hyprpolkitagent, ydotool)?"; then
  systemctl --user enable hyprpolkitagent.service 2>/dev/null || true
  systemctl --user enable rhp-battery-monitor.timer 2>/dev/null || true
  systemctl --user enable ydotool.service 2>/dev/null || true
  info "Services enabled."
fi

# ──────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────
header "Installation Complete"

echo "  Repo:  $REPO_ROOT"
echo "  Backup: ${BACKUP_DIR:-none}"
echo ""
echo -e "${YELLOW}Remaining manual steps:${NC}"
echo "  1. Set Zsh as default shell: chsh -s /bin/zsh"
echo "  2. Set a wallpaper: ~/.local/bin/aether-wallpaper"
echo "  3. Reboot or restart Hyprland"
echo "  4. Review ~/.gitconfig and ~/.zshenv"
echo ""
info "Done!"
