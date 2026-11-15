import QtQuick
import Quickshell
import Quickshell.Io

// Panels do not receive shell.appLibrary. Index installed app/device artwork
// as a fallback when Qt cannot resolve the configured icon theme.
Item {
  id: root

  property var index: ({})
  property var pendingIndex: ({})

  function refresh() {
    rescan.restart()
  }

  function scanCommand() {
    var home = Quickshell.env("HOME")
    var dataHome = Quickshell.env("XDG_DATA_HOME") || home + "/.local/share"
    var dataDirs = (Quickshell.env("XDG_DATA_DIRS") || "/usr/local/share:/usr/share").split(":")
    var paths = [home + "/.icons", dataHome + "/icons"]
    for (var i = 0; i < dataDirs.length; i++) {
      if (dataDirs[i]) paths.push(dataDirs[i] + "/icons")
    }
    paths.push("/usr/share/pixmaps")
    return ["find"].concat(paths, ["(", "-type", "f", "-o", "-type", "l", ")",
      "(", "-path", "*/apps/*", "-o", "-path", "*/devices/*", "-o", "-path", "/usr/share/pixmaps/*", ")",
      "(", "-name", "*.svg", "-o", "-name", "*.png", ")"])
  }

  function rasterSize(path) {
    var match = /\/(\d+)x(\d+)(?:@\d+)?\//.exec(path)
    return match ? Math.max(Number(match[1]), Number(match[2])) : 0
  }

  function addPath(path) {
    var file = path.slice(path.lastIndexOf("/") + 1)
    var name = file.replace(/\.(svg|png)$/, "")
    var previous = root.pendingIndex[name]
    // Prefer SVGs, then the largest PNG to avoid enlarging a tiny icon.
    if (!previous || (/\.svg$/.test(path) && /\.png$/.test(previous)) ||
        (/\.png$/.test(path) && /\.png$/.test(previous) && root.rasterSize(path) > root.rasterSize(previous)))
      root.pendingIndex[name] = path
  }

  function iconSource(name) {
    var path = root.index[name]
    return path ? "file://" + path.split("/").map(encodeURIComponent).join("/") : ""
  }

  Process {
    id: scan
    command: root.scanCommand()
    onStarted: root.pendingIndex = Object.create(null)
    stdout: SplitParser { onRead: function(line) { if (line) root.addPath(line) } }
    // Missing optional icon directories are normal.
    stderr: StdioCollector {}
    onExited: root.index = root.pendingIndex
  }

  Timer {
    id: rescan
    interval: 750
    repeat: true
    onTriggered: {
      if (scan.running) return
      stop()
      scan.running = true
    }
  }

  Connections {
    target: DesktopEntries.applications
    function onValuesChanged() { root.refresh() }
  }

  Component.onCompleted: scan.running = true
}
