.pragma library

// Cache only source geometry, not theme colors or rendered pixels.
var measuredBounds = Object.create(null)

function alphaBounds(pixels, width, height) {
    var left = width, top = height, right = -1, bottom = -1
    for (var y = 0; y < height; y++) {
        // Only the first and last opaque pixels in a row can extend its bounds.
        var rowAlpha = y * width * 4 + 3
        var first = 0
        while (first < width && pixels[rowAlpha + 4 * first] < 32) first++
        if (first === width) continue
        var last = width - 1
        while (last > first && pixels[rowAlpha + 4 * last] < 32) last--
        left = Math.min(left, first)
        right = Math.max(right, last)
        if (bottom < 0) top = y
        bottom = y
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
    module.exports = { alphaBounds: alphaBounds, placement: placement }
}
