#!/usr/bin/env bash
# Opens a small, non-interactive switcher on the current Hyprland desktop.
set -euo pipefail
cd "$(dirname "$0")/.."
fixture=$(mktemp -d /tmp/switcher-first-frame.XXXXXX)
trap 'rm -rf "$fixture"' EXIT

ln -s "$PWD" "$fixture/Switcher"
shell_root=/usr/share/omarchy/shell
ln -s "$shell_root" "$fixture/qs"
ln -s "$shell_root/Commons" "$fixture/Commons"
ln -s "$shell_root/Ui" "$fixture/Ui"
cp tests/fixtures/app-first-frame.qml "$fixture/shell.qml"
QML_IMPORT_PATH="$fixture" timeout 8s qs --no-color -p "$fixture/shell.qml"
