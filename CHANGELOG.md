# Changelog

## v0.6.0

### Added

- Show a frosted switcher background with antialiased corners when Omarchy
  animations are enabled.

### Changed

- Increase the panel's background opacity when Omarchy animations are disabled.

### Fixed

- Smooth the frosted switcher's rounded corners on light themes at fractional
  display scales.
- Open the switcher faster on a held shortcut by delivering key events directly
  from Hyprland and preparing the blur layer while keyboard input is set up.
- Show the app row and selection together on Super+Tab. The blur now waits for
  the foreground frame so it no longer flashes in the upper-left corner.

## v0.5.1

### Added

- Swap the Super and Alt/Option modifiers for app, window, and workspace
  switching with the `setShortcutModifiers` command.

### Fixed

- Recognize Wayland apps without a window class by matching their titles to
  installed desktop entries.
- Keep windows out of app and window switching until they are mapped.
- Size the switcher overlay to the card so it no longer covers the full screen.

## v0.5.0

### Changed

- Use Omarchy's shell socket for shortcut events on Omarchy 4.5 and later,
  with native Quickshell IPC support on earlier Quattro releases.

### Fixed

- Keep rapid app and window switches moving through the list even when
  Hyprland reports focus after the next tap.
- Restore the app switcher's most-recently-used order after a shell restart.
- Activate the selection when the modifier is released while the overlay is
  taking keyboard focus. Keep the current-workspace app filter in sync with
  the A key over the shell socket.
- Wait for the first window or workspace preview frames before showing the
  overlay, with a short timeout if a capture stalls.
- Keep app icons at a stable size when the switcher first appears or reopens.

## v0.4.0

### Added

- Hold the full app, window, or workspace shortcut to cycle automatically to
  the last entry. The Shift variant cycles to the first entry. Releasing Tab or
  the grave key stops automatic cycling while the modifier stays held.

### Fixed

- Resolve installed application icons even when the configured system icon theme
  is missing. Empty icon sources now display the bundled default artwork.

## v0.3.1

### Fixed

- Prevented stalled Hyprland IPC from accumulating helper processes. Modifier
  checks coalesce repeated input, and app and workspace IPC calls use a bounded
  queue. A deadline stops unresponsive requests.

## v0.3.0

### Added

- Press `` Super + ` `` to cycle through the focused app's windows across
  workspaces, or hold Shift to cycle in reverse. Quick taps follow a stable
  order so you can reach every window.
- Hold Super to see still previews when the app has at least two windows.
  The panel shows the app's icon and name above the previews and the selected
  window's title below its thumbnail. Release Super to focus the selected window.

### Changed

- Reworked the marketplace preview so both the app and workspace switchers fit
  in list thumbnails.
- Documented the window switcher shortcuts and refreshed the README demo video.

### Maintenance

- Extended tests to cover window filtering, cycle order, and shortcut registration.
- Added the local `AGENTS.md` file to `.gitignore`.

Commit range `7756f4d..fb75540`.
