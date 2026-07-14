#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# RHP-Config :: SDDM login screen setup
#
# Installs a Qylock (github.com/Darkkal44/qylock) SDDM theme and configures
# SDDM as the graphical display manager.
#
#   Usage: ./setup/sddm.sh [theme]
#          theme defaults to "material-you"
#
# The Qylock repo is ~560 MB (video-heavy themes), so it is cloned to a temp
# dir at install time and only the selected theme is copied into
# /usr/share/sddm/themes. Nothing large is committed to RHP-Config.
#
# Behaviour:
#   - X11 greeter (SDDM default; robust, no compositor juggling)
#   - Password login (no autologin)
#   - SDDM greeter takes tty1, session runs on tty2 (SDDM default)
#   - getty@tty1 stays enabled as a fallback console
#
# Pick the "Hyprland (uwsm)" session in the greeter on first login; SDDM
# remembers it afterwards.
# ──────────────────────────────────────────────

THEME="${1:-material-you}"
QYLOCK_URL="https://github.com/Darkkal44/qylock"
SYSTEM_THEMES_DIR="/usr/share/sddm/themes"
SDDM_CONF_DIR="/etc/sddm.conf.d"

# Qt6 runtime deps required by Qylock themes.
SDDM_PACKAGES=(
  sddm
  qt6-declarative
  qt6-5compat
  qt6-svg
  qt6-multimedia
  qt6-multimedia-ffmpeg
)

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
header(){ echo -e "\n${CYAN}━━━ $* ━━━${NC}\n"; }

header "SDDM Login Screen Setup (Qylock: ${THEME})"

# ── Sanity checks ────────────────────────────────
if [ "$(id -u)" -eq 0 ]; then
  error "Do not run as root. Run as a normal user with sudo access."
  exit 1
fi
if ! command -v git &>/dev/null; then
  error "git is required."
  exit 1
fi

# ── Dependencies ─────────────────────────────────
missing=()
for pkg in "${SDDM_PACKAGES[@]}"; do
  pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
done
if [ "${#missing[@]}" -gt 0 ]; then
  info "Installing missing packages: ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
else
  info "All required packages already installed."
fi

# ── Clone Qylock + copy selected theme ───────────
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

info "Cloning Qylock (shallow)…"
git clone --depth 1 "$QYLOCK_URL" "$TMP_DIR/qylock" >/dev/null 2>&1

if [ ! -d "$TMP_DIR/qylock/themes/$THEME" ]; then
  error "Theme '$THEME' not found in Qylock. Available themes:"
  ls -1 "$TMP_DIR/qylock/themes"
  exit 1
fi

info "Installing theme to ${SYSTEM_THEMES_DIR}/${THEME}…"
sudo mkdir -p "$SYSTEM_THEMES_DIR"
sudo rm -rf "${SYSTEM_THEMES_DIR:?}/${THEME}"
sudo cp -r "$TMP_DIR/qylock/themes/$THEME" "$SYSTEM_THEMES_DIR/$THEME"

# ── Write SDDM config drop-ins ───────────────────
info "Writing SDDM configuration to ${SDDM_CONF_DIR}…"
sudo mkdir -p "$SDDM_CONF_DIR"

sudo tee "$SDDM_CONF_DIR/10-theme.conf" >/dev/null <<EOF
[Theme]
Current=${THEME}
EOF

# DisplayServer=x11 is explicit (also SDDM's default). InputMethod is emptied
# to stop Qylock's virtual keyboard from popping up at the greeter.
sudo tee "$SDDM_CONF_DIR/10-general.conf" >/dev/null <<'EOF'
[General]
DisplayServer=x11
InputMethod=
Numlock=on
EOF

# ── Enable services ──────────────────────────────
# sddm.service Conflicts=getty@tty1 -> greeter takes tty1, session -> tty2.
# getty@tty1 stays enabled as a fallback if sddm ever stops.
info "Enabling sddm.service…"
sudo systemctl enable sddm.service

header "SDDM setup complete"
echo "  Theme:   ${THEME}  (${SYSTEM_THEMES_DIR}/${THEME})"
echo "  Config:  ${SDDM_CONF_DIR}/10-theme.conf, 10-general.conf"
echo ""
echo -e "${YELLOW}Next:${NC}"
echo "  - Test now from another VT:  sudo systemctl start sddm"
echo "  - Or just reboot."
echo "  - On first login, select the 'Hyprland (uwsm)' session."
echo "  - Change theme later:  ./setup/sddm.sh <theme-name>"
echo ""
info "Done!"
