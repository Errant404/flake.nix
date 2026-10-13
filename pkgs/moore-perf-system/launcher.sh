export XDG_CONFIG_DIRS="${XDG_CONFIG_HOME:-$HOME/.config}:${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_DATA_DIRS="${XDG_DATA_HOME:-$HOME/.local/share}:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
app_home="${XDG_DATA_HOME:-$HOME/.local/share}/moore-perf-system"
mkdir -p "$app_home"/{.config,.cache,.local/share,.local/state}

export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-xcb;wayland}"
exec bwrap \
  --die-with-parent \
  --bind / / \
  --dev-bind /dev /dev \
  --ro-bind /home /home \
  --bind "$app_home" "$app_home" \
  --setenv HOME "$app_home" \
  --setenv XDG_CONFIG_HOME "$app_home/.config" \
  --setenv XDG_CACHE_HOME "$app_home/.cache" \
  --setenv XDG_DATA_HOME "$app_home/.local/share" \
  --setenv XDG_STATE_HOME "$app_home/.local/state" \
  --chdir "$app_home" \
  '@appDir@/@executable@' "$@"
