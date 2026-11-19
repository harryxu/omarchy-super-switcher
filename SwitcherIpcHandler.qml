import QtQuick
import Quickshell.Io
import qs.Commons as Commons

IpcHandler {
  id: handler

  // Quattro releases before Omarchy 4.5 only support native Quickshell IPC.
  Component.onCompleted: {
    if (Commons.IpcRegistry) Commons.IpcRegistry.register(handler)
  }
  Component.onDestruction: {
    if (Commons.IpcRegistry) Commons.IpcRegistry.unregister(handler)
  }
}
