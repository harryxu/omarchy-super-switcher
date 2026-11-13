.pragma library

// Cache only source geometry, not theme colors or rendered pixels.
var measuredBounds = Object.create(null)
// Bumped whenever a new measurement lands, so the shell can persist the cache.
var revision = 0

function cachedBounds(source) {
    var value = measuredBounds[String(source)]
    return value ? value : null
}

function remember(source, bounds) {
    measuredBounds[String(source)] = bounds
    revision++
}

function restore(json) {
    try {
        var data = JSON.parse(json)
        for (var key in data) {
            var b = data[key]
            if (b && b.width > 0 && b.height > 0 && measuredBounds[key] === undefined)
                measuredBounds[key] = { x: b.x, y: b.y, width: b.width, height: b.height }
        }
    } catch (e) {}
}

function serialize() {
    return JSON.stringify(measuredBounds)
}

function alphaBounds(pixels, width, height) {
    var left = width, top = height, right = -1, bottom = -1
    for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
            // Ignore faint drop shadows when measuring the artwork itself.
            if (pixels[(y * width + x) * 4 + 3] < 32) continue
            left = Math.min(left, x)
            top = Math.min(top, y)
            right = Math.max(right, x)
            bottom = Math.max(bottom, y)
        }
    }
    return right < left ? null : { x: left, y: top, width: right - left + 1, height: bottom - top + 1 }
}

function placement(bounds, canvasSize, artworkSize) {
    if (!bounds || Math.max(bounds.width, bounds.height) <= 0) return null
    var scale = artworkSize / Math.max(bounds.width, bounds.height)
    return {
        scale: scale,
        x: canvasSize / 2 - (bounds.x + bounds.width / 2) * scale,
        y: canvasSize / 2 - (bounds.y + bounds.height / 2) * scale
    }
}

if (typeof module !== "undefined" && module.exports) {
    module.exports = { alphaBounds: alphaBounds, placement: placement, cachedBounds: cachedBounds, remember: remember, restore: restore, serialize: serialize }
}
