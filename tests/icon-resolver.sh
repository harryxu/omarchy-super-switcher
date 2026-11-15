#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

fixture=$(mktemp -d /tmp/switcher-icons.XXXXXX)
trap 'rm -rf "$fixture"' EXIT
mkdir -m 700 "$fixture/runtime"
mkdir -p "$fixture/data/icons/test/48x48/apps" "$fixture/data/icons/test/scalable/apps"
cp tests/fixtures/icon-solid.svg "$fixture/data/icons/test/scalable/apps/switcher-test #icon.svg"
touch "$fixture/data/icons/test/48x48/apps/switcher-test #icon.png"
ln -s "$PWD/IconResolver.qml" "$fixture/IconResolver.qml"
cat > "$fixture/shell.qml" <<'QML'
import QtQuick
import Quickshell

ShellRoot {
  IconResolver { id: resolver }
  property int phase: 0
  Timer {
    interval: 50; running: true; repeat: true
    onTriggered: {
      var source = resolver.iconSource("switcher-test #icon")
      if (!source) return
      if (!source.endsWith("/scalable/apps/switcher-test%20%23icon.svg") || resolver.iconSource("switcher-nonexistent-icon") !== "") {
        console.error("FAIL: wrong indexed icon", source)
        Qt.exit(1)
      }
      image.source = source
      if (image.status !== Image.Ready) return
      if (phase === 0) {
        resolver.pendingIndex = Object.create(null)
        resolver.addPath("/test/24x24/apps/raster.png")
        resolver.addPath("/test/256x256/apps/raster.png")
        resolver.addPath("/test/48x48/apps/raster.png")
        if (resolver.pendingIndex.raster !== "/test/256x256/apps/raster.png") {
          console.error("FAIL: largest raster was not selected")
          Qt.exit(1)
        }
        phase = 1
        resolver.index = ({})
        resolver.refresh()
        return
      }
      console.log("PASS: missing theme fallback, SVG and raster priority, URL escaping, refresh and image loading")
      Qt.exit(0)
    }
  }
  Image { id: image }
}
QML

env -u HYPRLAND_INSTANCE_SIGNATURE -u WAYLAND_DISPLAY -u DISPLAY \
  QT_QPA_PLATFORM=offscreen QT_QPA_PLATFORMTHEME= \
  XDG_RUNTIME_DIR="$fixture/runtime" XDG_CONFIG_HOME="$fixture/config" \
  XDG_CACHE_HOME="$fixture/cache" XDG_DATA_HOME="$fixture/data" XDG_DATA_DIRS="$fixture/empty" \
  timeout --kill-after=1s 6s qs --no-color -p "$fixture/shell.qml"
