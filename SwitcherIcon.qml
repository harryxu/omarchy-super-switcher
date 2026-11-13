import QtQuick
import "IconGeometry.js" as Geometry

// Sample the native rendering once per source. Fit and center the visible
// artwork within artworkSize, ignoring transparent padding and faint shadows.
Item {
  id: root

  required property url source
  property real artworkSize: 84
  readonly property int sampleSize: 210
  property url displaySource: source
  // Resolve cached geometry synchronously so the very first frame already has
  // the final size; a deferred lookup showed one frame at the fallback size.
  property var bounds: Geometry.cachedBounds(source)
  property var grabResult: null
  property bool measuring: false
  readonly property var placement: root.width > 0 ? Geometry.placement(root.bounds, root.sampleSize, root.artworkSize * root.sampleSize / root.width) : null

  // The row is created while the panel is still unmapped (so previews warm up
  // during the hold delay). Grabbing an item in an unmapped window yields an
  // empty or partial frame, which used to be cached as this icon's bounds and
  // left it invisible or mis-scaled. Measure only once the window is shown.
  readonly property bool windowShown: root.Window.window ? root.Window.window.visible : false
  onWindowShownChanged: if (root.windowShown) Qt.callLater(root.measure)

  function measure() {
    if (!root.windowShown || !sampler.available || original.status !== Image.Ready || root.measuring || root.bounds) return
    var key = String(root.displaySource)
    var cached = Geometry.cachedBounds(key)
    if (cached) { root.bounds = cached; return }
    root.measuring = true
    // Capture Qt's actual rendering, then sample it on one fixed pixel grid.
    // Theme image providers can otherwise report different native DPRs.
    var started = original.grabToImage(function(result) {
      if (!root || key !== String(root.displaySource)) return
      if (!root.windowShown) { root.measuring = false; return }
      root.grabResult = result
      sampler.loadImage(result.url)
      // Item grabs can load synchronously without an imageLoaded signal.
      sampler.requestPaint()
    }, Qt.size(root.sampleSize, root.sampleSize))
    if (!started) root.measuring = false
  }

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
      if (!root.grabResult || !isImageLoaded(root.grabResult.url)) return
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, root.sampleSize, root.sampleSize)
      ctx.drawImage(root.grabResult.url, 0, 0, root.sampleSize, root.sampleSize)
        var bounds = Geometry.alphaBounds(ctx.getImageData(0, 0, root.sampleSize, root.sampleSize).data, root.sampleSize, root.sampleSize)
      ctx.clearRect(0, 0, root.sampleSize, root.sampleSize)
      // A blank or sliver capture means the frame was not rendered yet. Keep
      // the unscaled icon and do not poison the shared cache with it.
      if (bounds && Math.min(bounds.width, bounds.height) >= root.sampleSize / 8) {
        root.bounds = bounds
        Geometry.remember(String(root.displaySource), bounds)
      }
      unloadImage(root.grabResult.url)
      root.grabResult = null
      root.measuring = false
    }
  }

  onDisplaySourceChanged: {
    root.bounds = Geometry.cachedBounds(root.displaySource)
    root.grabResult = null
    root.measuring = false
    Qt.callLater(root.measure)
  }
  onSourceChanged: root.displaySource = source
}
