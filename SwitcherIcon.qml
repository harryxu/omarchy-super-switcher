import QtQuick
import "IconGeometry.js" as Geometry

// Sample the native rendering once per source. Fit and center the visible
// artwork within artworkSize, ignoring transparent padding and faint shadows.
Item {
  id: root

  required property url source
  property real artworkSize: 84
  readonly property int sampleSize: 210
  property url displaySource: String(source) ? source : Qt.resolvedUrl("assets/default-app.svg")
  property var bounds: Geometry.measuredBounds[String(root.displaySource)] || null
  property var grabResult: null
  property bool measuring: false
  property int measurementRevision: 0
  property bool fallbackVisible: false
  readonly property bool canMeasure: root.visible && !!root.Window.window && root.Window.window.visible
  readonly property bool artworkReady: !!root.bounds || root.fallbackVisible
  readonly property var placement: root.width > 0 ? Geometry.placement(root.bounds, root.sampleSize, root.artworkSize * root.sampleSize / root.width) : null

  function measure() {
    if (!root.canMeasure || original.status !== Image.Ready || root.bounds || root.measuring) return
    var key = String(root.displaySource)
    var cached = Geometry.measuredBounds[key]
    if (cached) {
      if (!root.fallbackVisible) root.bounds = cached
      fallbackDeadline.stop()
      return
    }
    if (!root.fallbackVisible) fallbackDeadline.start()
    if (!sampler.available) return
    root.measuring = true
    var revision = root.measurementRevision
    // Capture Qt's actual rendering, then sample it on one fixed pixel grid.
    // Theme image providers can otherwise report different native DPRs.
    var started = original.grabToImage(function(result) {
      if (!root || !root.canMeasure || revision !== root.measurementRevision) return
      sampler.loadImage(result.url)
      root.grabResult = result
      // Item grabs can load synchronously without an imageLoaded signal.
      sampler.requestPaint()
    }, Qt.size(root.sampleSize, root.sampleSize))
    if (!started) root.measuring = false
  }

  function cancelMeasurement() {
    root.measurementRevision++
    fallbackDeadline.stop()
    if (root.grabResult) sampler.unloadImage(root.grabResult.url)
    root.grabResult = null
    root.measuring = false
  }

  onCanMeasureChanged: {
    if (root.canMeasure) Qt.callLater(root.measure)
    else root.cancelMeasurement()
  }

  Timer {
    id: fallbackDeadline
    interval: 120
    onTriggered: root.fallbackVisible = true
  }

  Item {
    anchors.fill: parent
    // Take the measurement from the image itself while its parent is transparent.
    opacity: root.artworkReady ? 1 : 0

    Image {
      id: original
      width: root.placement ? root.width * root.placement.scale : root.artworkSize
      height: root.placement ? root.height * root.placement.scale : root.artworkSize
      x: root.placement ? root.placement.x * root.width / root.sampleSize : (root.width - width) / 2
      y: root.placement ? root.placement.y * root.height / root.sampleSize : (root.height - height) / 2
      source: root.displaySource
      sourceSize: Qt.size(root.sampleSize, root.sampleSize)
      fillMode: Image.PreserveAspectFit
      cache: true
      onStatusChanged: {
        if (status === Image.Ready) Qt.callLater(root.measure)
        else if (status === Image.Error && source !== Qt.resolvedUrl("assets/default-app.svg"))
          root.displaySource = Qt.resolvedUrl("assets/default-app.svg")
      }
    }
  }

  Canvas {
    id: sampler
    // Keep the item, viewport, and pixel grid the same size. Scaling a 210px
    // canvas into the smaller icon item changes the sampled alpha bounds on
    // HiDPI displays and consequently enlarges and offsets the visible icon.
    width: root.sampleSize
    height: root.sampleSize
    opacity: 0
    visible: !root.bounds
    canvasSize: Qt.size(root.sampleSize, root.sampleSize)
    renderTarget: Canvas.Image
    contextType: "2d"
    onAvailableChanged: if (available) Qt.callLater(root.measure)
    onImageLoaded: requestPaint()
    onPaint: sample()
    function sample() {
      if (!root.canMeasure || !root.grabResult || !isImageLoaded(root.grabResult.url)) return
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, root.sampleSize, root.sampleSize)
      ctx.drawImage(root.grabResult.url, 0, 0, root.sampleSize, root.sampleSize)
      var bounds = Geometry.alphaBounds(ctx.getImageData(0, 0, root.sampleSize, root.sampleSize).data, root.sampleSize, root.sampleSize)
      ctx.clearRect(0, 0, root.sampleSize, root.sampleSize)
      unloadImage(root.grabResult.url)
      root.grabResult = null
      root.measuring = false
      fallbackDeadline.stop()
      // A late measurement can help the next open without resizing this icon.
      if (bounds) Geometry.measuredBounds[String(root.displaySource)] = bounds
      if (!root.fallbackVisible) {
        if (bounds) root.bounds = bounds
        else root.fallbackVisible = true
      }
    }
  }

  onDisplaySourceChanged: {
    root.cancelMeasurement()
    root.bounds = Geometry.measuredBounds[String(root.displaySource)] || null
    root.fallbackVisible = false
    Qt.callLater(root.measure)
  }
  onSourceChanged: root.displaySource = String(source) ? source : Qt.resolvedUrl("assets/default-app.svg")
}
