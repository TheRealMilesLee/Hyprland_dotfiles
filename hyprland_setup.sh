#!/bin/bash

# Hyprland 环境配置脚本

# 更新系统
sudo pacman -Syu

# 安装必要软件
sudo pacman -S waybar rofi dunst alacritty thunar network-manager-applet \
  brightnessctl pavucontrol pipewire pipewire-pulse polkit-gnome \
  grim slurp wl-clipboard cava fish plank lxappearance yay --noconfirm

# 将 fish 设为默认 shell
chsh -s /usr/bin/fish

# 配置 fish
mkdir -p ~/.config/fish
cat <<EOF >~/.config/fish/config.fish
# Fish 配置
set -g fish_greeting ""
set -U EDITOR nvim

# 彩色提示
set -g fish_color_command green
set -g fish_color_quote yellow
set -g fish_color_error red
set -g fish_color_param blue

# 启用彩色 ls
alias ls='ls --color=auto'

# Path
set -x PATH \$PATH:\$HOME/.local/bin
EOF

# 安装 oh-my-fish
curl -L https://get.oh-my.fish | fish
fish -c "omf install bobthefish"

# 安装 One UI 图标主题
yay -S tela-icon-theme --noconfirm

# 创建 Hyprland 配置目录
mkdir -p ~/.config/hypr

# Hyprland 主配置文件
cat <<EOF >~/.config/hypr/hyprland.conf
# Hyprland 主配置文件

# ---------------------
# 启动相关
exec-once = waybar & nm-applet & dunst & hyprpaper & plank

# ---------------------
# 外观
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    active_border_color = rgba(89ccffee)
    inactive_border_color = rgba(444444aa)
    layout = dwindle
}

# ---------------------
# 键位绑定
bind = SUPER, T, exec, alacritty -e fish
bind = SUPER, E, exec, thunar
bind = SUPER, Q, killactive
bind = SUPER, D, exec, rofi -show drun
bind = SUPER, , exec, rofi -show window

# 窗口管理
bind = SUPER, F, fullscreen
bind = SUPER, Left, movefocus, l
bind = SUPER, Right, movefocus, r
bind = SUPER, Up, movefocus, u
bind = SUPER, Down, movefocus, d

# 音量和亮度控制
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

# ---------------------
# 动画效果
animations {
    enabled = true
    bezier = ease, 0.25, 0.1, 0.25, 1.0
    animation = windows, ease, 5, 10
    animation = workspaces, ease, 5, 6
}

# ---------------------
# 托盘和壁纸
exec-once = nm-applet & hyprpaper & waybar & plank

# 壁纸配置
hyprpaper {
    preload = ~/Pictures/Wallpapers/default.jpg
    wallpaper = , ~/Pictures/Wallpapers/default.jpg
}

# ---------------------
# 其他设置
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = yes
    }
}

misc {
    mouse_move_enables_dpms = true
    disable_hyprland_logo = true
}
EOF

# Waybar 配置
mkdir -p ~/.config/waybar
cat <<EOF >~/.config/waybar/config.jsonc
{
  "modules-left": ["custom/dock", "hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["network", "battery", "pulseaudio", "tray"],

  "custom/dock": {
    "format": " {}",
    "exec": "cava",
    "interval": 1,
    "tooltip": false
  },

  "clock": {
    "format": "{:%Y-%m-%d %H:%M:%S}",
    "interval": 1
  },

  "network": {
    "format": " {essid} {signalStrength}%",
    "tooltip": true
  },

  "battery": {
    "format": " {capacity}%",
    "interval": 30
  },

  "pulseaudio": {
    "format": " {volume}%",
    "tooltip": true
  },

  "tray": {
    "icon-size": 20,
    "spacing": 10
  }
}
EOF

# 结束
echo "Hyprland 环境配置完成！请重新启动 Hyprland。"
