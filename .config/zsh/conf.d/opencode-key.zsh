# Opencode hosted API gateway key — used by minuet-ai.nvim for ghost-text completion
# Resolution order (first match wins):
#   1. existing env var
#   2. freedesktop Secret Service (secret-tool) — keyring must be unlocked
#   3. plain file ~/.config/opencode/api_key (chmod 600, gitignored)
if [ -z "${OPENCODE_GO_API_KEY:-}" ]; then
  OPENCODE_GO_API_KEY="$(secret-tool lookup application opencode key api_key 2>/dev/null)"
fi
if [ -z "${OPENCODE_GO_API_KEY:-}" ] && [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/api_key" ]; then
  OPENCODE_GO_API_KEY="$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/api_key")"
fi
export OPENCODE_GO_API_KEY
