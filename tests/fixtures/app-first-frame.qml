import QtQuick
import Quickshell
import Quickshell.Wayland
import "Switcher" as Switcher

ShellRoot {
  id: test
  property int opens: 0
  property bool sawCompleteFrame: false

  Switcher.SwitcherPanel {
    id: panel
    active: true
    inputReady: true
    targetScreen: Quickshell.screens[0]
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    mask: Region {}
    slotWidth: 48
    artworkSize: 40
    selectedIndex: 1
    apps: ["solid", "padded", "narrow"].map(name => ({ id: name, name: name }))
    iconSourceFor: app => Qt.resolvedUrl("Switcher/tests/fixtures/icon-" + app.id + ".svg")
  }

  function countReadyIcons(item) {
    if (item instanceof Switcher.SwitcherIcon) return item.artworkReady ? 1 : 0
    var ready = 0
    for (var child of item.children) ready += countReadyIcons(child)
    return ready
  }

  Connections {
    target: panel.contentItem.Window.window
    function onFrameSwapped() {
      if (!panel.surfaceRevealed) return
      var ready = test.countReadyIcons(panel.contentItem)
      if (ready !== panel.apps.length) {
        console.error("Visible app frame contained", ready, "of", panel.apps.length, "icons")
        Qt.exit(1)
      }
      test.sawCompleteFrame = true
    }
  }

  Timer {
    interval: 450
    running: true
    repeat: true
    onTriggered: {
      if (panel.showRequested) {
        if (!test.sawCompleteFrame) { console.error("App row never appeared"); Qt.exit(1); return }
        panel.showRequested = false
      } else if (test.opens === 2) {
        console.log("PASS: cold and cached app rows appeared complete")
        Qt.quit()
      } else {
        test.opens++
        test.sawCompleteFrame = false
        panel.showRequested = true
      }
    }
  }
}
