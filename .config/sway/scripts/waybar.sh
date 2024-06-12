#!/usr/bin/env bash
# wrapper script for waybar with args, see https://github.com/swaywm/sway/issues/5724
CONFIG_PATH=$HOME/.config/waybar/config.jsonc
STYLE_PATH=$HOME/.config/waybar/style.css

pkill -x waybar
waybar -c "${CONFIG_PATH}" -s "${STYLE_PATH}" > $(mktemp -t XXXX.waybar.log)
