#!/bin/bash
set -euo pipefail

THEME_DIR="$HOME/.config/quickshell/ii/theme"
AETHER_JSON="$THEME_DIR/colors.json"
OUTPUT_JSON="$THEME_DIR/AetherTheme.json"

read_colors() {
    if [ -f "$AETHER_JSON" ]; then
        PALETTE=$(jq -r '.palette // [] | join("|")' "$AETHER_JSON")
        ACCENT=$(jq -r '.accent // ""' "$AETHER_JSON")
        BG=$(jq -r '.bg // ""' "$AETHER_JSON")
        FG=$(jq -r '.fg // ""' "$AETHER_JSON")
    fi

    if [ -z "$PALETTE" ]; then
        JSON=$(aether status --json 2>/dev/null || echo '{"palette":["#141313","#ffb4ab","#B5CCBA","#df6124","#cbc4cb","#cac5c8","#d1c3c6","#e6e1e1","#3a3939","#ffb4ab","#B5CCBA","#df6124","#cbc4cb","#cac5c8","#d1c3c6","#e6e1e1"]}')
        PALETTE=$(echo "$JSON" | jq -r '.palette | join("|")')
        ACCENT="${ACCENT:-$(echo "$JSON" | jq -r '.palette[4] // "#cbc4cb"')}"
        BG="${BG:-$(echo "$JSON" | jq -r '.palette[0] // "#141313"')}"
        FG="${FG:-$(echo "$JSON" | jq -r '.palette[7] // "#e6e1e1"')}"
    fi

    IFS='|' read -ra P <<< "$PALETTE"
    P0="${P[0]:-#141313}" P1="${P[1]:-#ffb4ab}" P2="${P[2]:-#B5CCBA}" P3="${P[3]:-#df6124}"
    P4="${P[4]:-#cbc4cb}" P5="${P[5]:-#cac5c8}" P6="${P[6]:-#d1c3c6}" P7="${P[7]:-#e6e1e1}"
    P8="${P[8]:-#3a3939}" P9="${P[9]:-#ffb4ab}" P10="${P[10]:-#B5CCBA}" P11="${P[11]:-#df6124}"
    P12="${P[12]:-#cbc4cb}" P13="${P[13]:-#cac5c8}" P14="${P[14]:-#d1c3c6}" P15="${P[15]:-#e6e1e1}"
    ACCENT="${ACCENT:-$P4}"
}

lighten() {
    local hex="$1" factor="$2"
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    r=$(printf "%.0f" "$(echo "255 - (255 - $r) * $factor" | bc -l 2>/dev/null || echo "$r")")
    g=$(printf "%.0f" "$(echo "255 - (255 - $g) * $factor" | bc -l 2>/dev/null || echo "$g")")
    b=$(printf "%.0f" "$(echo "255 - (255 - $b) * $factor" | bc -l 2>/dev/null || echo "$b")")
    [ "$r" -gt 255 ] && r=255; [ "$g" -gt 255 ] && g=255; [ "$b" -gt 255 ] && b=255
    [ "$r" -lt 0 ] && r=0; [ "$g" -lt 0 ] && g=0; [ "$b" -lt 0 ] && b=0
    printf "#%02x%02x%02x" "$r" "$g" "$b"
}

darken() {
    local hex="$1" factor="$2"
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    r=$(printf "%.0f" "$(echo "$r * $factor" | bc -l 2>/dev/null || echo "$r")")
    g=$(printf "%.0f" "$(echo "$g * $factor" | bc -l 2>/dev/null || echo "$g")")
    b=$(printf "%.0f" "$(echo "$b * $factor" | bc -l 2>/dev/null || echo "$b")")
    [ "$r" -gt 255 ] && r=255; [ "$g" -gt 255 ] && g=255; [ "$b" -gt 255 ] && b=255
    [ "$r" -lt 0 ] && r=0; [ "$g" -lt 0 ] && g=0; [ "$b" -lt 0 ] && b=0
    printf "#%02x%02x%02x" "$r" "$g" "$b"
}

read_colors

LIGHT_MODE=$(aether status --json 2>/dev/null | jq -r '.light_mode // false')
if [ "$LIGHT_MODE" = "true" ]; then
    SURFACE_DIM="$P8"
    SURFACE_BRIGHT="$P0"
    SURFACE_CONTAINER_LOWEST=$(darken "$P0" 0.85)
    SURFACE_CONTAINER_LOW=$(darken "$P0" 0.78)
    SURFACE_CONTAINER=$(darken "$P0" 0.70)
    SURFACE_CONTAINER_HIGH=$(darken "$P0" 0.62)
    SURFACE_CONTAINER_HIGHEST=$(darken "$P0" 0.55)
    SURFACE_VARIANT="$P8"
    ON_SURFACE_VARIANT="$P8"
    INVERSE_SURFACE="$P8"
    INVERSE_ON_SURFACE="$P7"
    OUTLINE="$P8"
    OUTLINE_VARIANT="$P8"
else
    SURFACE_DIM=$(darken "$P0" 0.88)
    SURFACE_BRIGHT=$(lighten "$P0" 0.88)
    SURFACE_CONTAINER_LOWEST=$(lighten "$P0" 0.88)
    SURFACE_CONTAINER_LOW=$(lighten "$P0" 0.84)
    SURFACE_CONTAINER=$(lighten "$P0" 0.80)
    SURFACE_CONTAINER_HIGH=$(lighten "$P0" 0.76)
    SURFACE_CONTAINER_HIGHEST=$(lighten "$P0" 0.72)
    SURFACE_VARIANT="$P8"
    ON_SURFACE_VARIANT="$P7"
    INVERSE_SURFACE=$(darken "$P8" 0.3)
    INVERSE_ON_SURFACE="$P7"
    OUTLINE="$P8"
    OUTLINE_VARIANT="$P8"
fi
PRIMARY="$ACCENT"
ON_PRIMARY="$P0"
PRIMARY_CONTAINER=$(lighten "$ACCENT" 0.25)
ON_PRIMARY_CONTAINER="$P7"
INVERSE_PRIMARY=$(lighten "$ACCENT" 0.50)
SECONDARY="$P5"
ON_SECONDARY="$P0"
SECONDARY_CONTAINER=$(lighten "$P5" 0.25)
ON_SECONDARY_CONTAINER="$P7"
TERTIARY="$P6"
ON_TERTIARY="$P0"
TERTIARY_CONTAINER=$(lighten "$P6" 0.25)
ON_TERTIARY_CONTAINER="$P7"
ERROR="$P1"
ON_ERROR="$P0"
ERROR_CONTAINER=$(darken "$P1" 0.60)
ON_ERROR_CONTAINER="$P1"
SUCCESS="$P2"
ON_SUCCESS="$P0"
SUCCESS_CONTAINER=$(darken "$P2" 0.60)
ON_SUCCESS_CONTAINER="$P2"
TINT="$ACCENT"
SHADOW="#000000"
SCRIM="#000000"

cat > "$OUTPUT_JSON" << EOF
{
    "background": "$P0",
    "on_background": "$P7",
    "surface": "$P0",
    "surface_dim": "$SURFACE_DIM",
    "surface_bright": "$SURFACE_BRIGHT",
    "surface_container_lowest": "$SURFACE_CONTAINER_LOWEST",
    "surface_container_low": "$SURFACE_CONTAINER_LOW",
    "surface_container": "$SURFACE_CONTAINER",
    "surface_container_high": "$SURFACE_CONTAINER_HIGH",
    "surface_container_highest": "$SURFACE_CONTAINER_HIGHEST",
    "on_surface": "$P7",
    "surface_variant": "$SURFACE_VARIANT",
    "on_surface_variant": "$ON_SURFACE_VARIANT",
    "inverse_surface": "$INVERSE_SURFACE",
    "inverse_on_surface": "$INVERSE_ON_SURFACE",
    "outline": "$OUTLINE",
    "outline_variant": "$OUTLINE_VARIANT",
    "shadow": "$SHADOW",
    "scrim": "$SCRIM",
    "surface_tint": "$TINT",
    "primary": "$PRIMARY",
    "on_primary": "$ON_PRIMARY",
    "primary_container": "$PRIMARY_CONTAINER",
    "on_primary_container": "$ON_PRIMARY_CONTAINER",
    "inverse_primary": "$INVERSE_PRIMARY",
    "secondary": "$SECONDARY",
    "on_secondary": "$ON_SECONDARY",
    "secondary_container": "$SECONDARY_CONTAINER",
    "on_secondary_container": "$ON_SECONDARY_CONTAINER",
    "tertiary": "$TERTIARY",
    "on_tertiary": "$ON_TERTIARY",
    "tertiary_container": "$TERTIARY_CONTAINER",
    "on_tertiary_container": "$ON_TERTIARY_CONTAINER",
    "error": "$ERROR",
    "on_error": "$ON_ERROR",
    "error_container": "$ERROR_CONTAINER",
    "on_error_container": "$ON_ERROR_CONTAINER",
    "primary_fixed": "$PRIMARY",
    "primary_fixed_dim": "$PRIMARY",
    "on_primary_fixed": "$ON_PRIMARY",
    "on_primary_fixed_variant": "$ON_PRIMARY",
    "secondary_fixed": "$SECONDARY",
    "secondary_fixed_dim": "$SECONDARY",
    "on_secondary_fixed": "$ON_SECONDARY",
    "on_secondary_fixed_variant": "$ON_SECONDARY",
    "tertiary_fixed": "$TERTIARY",
    "tertiary_fixed_dim": "$TERTIARY",
    "on_tertiary_fixed": "$ON_TERTIARY",
    "on_tertiary_fixed_variant": "$ON_TERTIARY",
    "success": "$SUCCESS",
    "on_success": "$ON_SUCCESS",
    "success_container": "$SUCCESS_CONTAINER",
    "on_success_container": "$ON_SUCCESS_CONTAINER"
}
EOF

chmod 644 "$OUTPUT_JSON"
echo "AetherTheme.json written"
