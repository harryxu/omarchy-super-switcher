# AGENTS.md

## Project

Omarchy Super Switcher is a Qt Quick and JavaScript plugin loaded by the Omarchy
Quickshell process. Runtime checks require the Quickshell-based Omarchy shell
and Hyprland 0.56 or later with its Lua API. The plugin loads directly from the
source files.

- [manifest.json](manifest.json) declares the plugin ID and the panel entry point.
  [Switcher.qml](Switcher.qml) owns compositor state, IPC, focus, and the
  switcher sessions.
- [SwitcherKeys.js](SwitcherKeys.js) builds Hyprland Lua commands for shortcuts,
  modifier tracking, and entering or leaving the switcher submap.
- [SwitcherPanel.qml](SwitcherPanel.qml) provides the shared overlay and input
  handling. `SwitcherIcon.qml`, `WindowPreview.qml`, and `WorkspacePreview.qml`
  render the three kinds of entries.
- `SwitcherModel.js`, `WorkspaceModel.js`, and `IconGeometry.js` contain
  grouping, ordering, selection, and geometry logic. Keep this logic testable
  under Node as well as usable from QML.

## Behavior to preserve

- `Super+Tab` cycles apps by most recent focus. Holding `A` scopes app
  selection and activation to the current workspace.
- `Super+grave` cycles the focused app's windows across workspaces in stable
  order so consecutive quick taps can reach every window. The panel opens
  only while at least two matching windows exist.
- `Alt+Tab` cycles regular workspaces across monitors, including empty ones.
  Window previews are stills. Workspace previews use the configured static
  or live mode.
- All modes share the hold delay and activate on modifier release. Quick taps
  commit without mapping the panel or capturing previews. Keep physical
  modifier tracking for Alt/Win swaps and generation checks for stale IPC
  replies.
- Register global bindings before their submap copies because Hyprland's
  unbind operation can remove both. Keep the IPC target
  `harryxu.super-switcher` distinct from the Hyprland submap
  `harryxu-super-switcher`. Restore runtime bindings after compositor reload.

## Development checks

Run the checks that cover your change from the repository root:

```bash
tests/run.sh
tests/render.sh
tests/request-deadline.sh
/usr/lib/qt6/bin/qmllint --ignore-settings --only-explicit-categories --syntax error ./*.qml
omarchy plugin validate .
```

The unit suite uses Node's built-in test runner and calls standalone `lua` to
exercise generated binding commands. The render suite checks icon rendering
offscreen at multiple scale factors and accepts a `QMLTESTRUNNER` override.
The request deadline test runs an isolated offscreen Quickshell instance and
checks that each child gets its own deadline, including back-to-back requests.
Use the Qt 6 linter for QML. The `tests/*-live.test.py` scripts require an
enabled plugin on an unlocked Hyprland desktop and temporarily change focus,
switch workspaces, or reload the compositor. Read the script's prerequisites
before running it in a live session.

## Editing and local deployment

Match the formatting of the file you edit. Render window titles and other
client-provided labels with `Text.PlainText`. Reuse the existing validation
and quoting helpers when constructing Lua commands from window addresses or
workspace names. Update the README when a shortcut or setting changes.

Keep routine edits in this checkout. For a requested desktop deployment, check
whether the installed plugin under `~/.config/omarchy/plugins/harryxu.super-switcher/`
is a symlink or a separate checkout. Back up a separate installation before
replacing its runtime files. Use `omarchy-shell shell rescanPlugins` to refresh
discovery and `omarchy restart shell` if cached components need reloading.
Verify the plugin and its bindings in the running session.

## Releasing a version

1. Review the commits and diff from the last release tag through the intended
   release commit. In `CHANGELOG.md`, add any user-facing changes from that
   range that are missing from `Unreleased`, then move those notes under the
   new `vX.Y.Z` heading. Set `manifest.json` to the matching `X.Y.Z` version.
2. Run the relevant development checks above, including `omarchy plugin validate .`.
   Confirm the root manifest, README installation and removal instructions, and
   license are present. Check the preview if it changed. This plugin uses Omarchy's
   standard `omarchy plugin add` installation and enablement path.
3. Commit the release files, push the commit to the public default branch, and
   push a `vX.Y.Z` tag for that commit. Publish a stable GitHub Release in
   `harryxu/omarchy-super-switcher` using that version's changelog entry as the
   release notes. Verify that the published tag and remote default branch HEAD
   point to the same commit. [GitHub Releases](https://github.com/harryxu/omarchy-super-switcher/releases)
4. For a new version of the listed plugin, submit a marketplace Issue titled
   `[Verify]: Omarchy Super Switcher vX.Y.Z`. Choose **Verify and publish a newer
   upstream commit**, enter plugin ID `harryxu.super-switcher`, repository URL
   `https://github.com/harryxu/omarchy-super-switcher`, and the full 40-character
   SHA of the remote default branch HEAD. Check **Verification acknowledgment**.
   Use **Standard installation acknowledgment** when requesting removal of an
   explicit manual installation override. [Marketplace update form](https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=verify-plugin.yml)
5. Verify that the marketplace bot reports Quattro compatibility and the
   automated security baseline for the submitted SHA. After maintainer approval
   and deployment, verify the version, snapshot commit, and **Standard Installation**
   on the public listing. [Marketplace update rules](https://github.com/omacom/omarchy-plugin-marketplace/blob/main/VERIFICATION.md#promoting-a-plugin-update) · [Plugin listing](https://plugins.omarchy.org/plugin.html?id=harryxu.super-switcher)

### Handling marketplace update feedback

1. Read the maintainer's feedback on the pending update Issue and identify the
   reviewed commit. Reproduce the reported failure and verify the fix against
   normal switcher behavior. For Hyprland IPC changes, test stalled helpers,
   repeated requests, timeout recovery, and stale replies in an isolated session.
2. Prepare and publish a new patch release using steps 1–3 above.
3. Edit the existing Issue for that pending update. Set its title to the patch
   version and replace the target with the full SHA of the new remote default
   branch HEAD. Preserve the update action, plugin ID, repository URL, and
   verification acknowledgment. Confirm the bot refreshed both reports for the
   new SHA, then verify the listing after the maintainer approves and deploys it.

## Agent skills

### Issue tracker

Use GitHub Issues by default and `.scratch/` for explicitly local work. See [Issue tracker](docs/agents/issue-tracker.md).

### Triage labels

Use the five canonical triage labels for GitHub issues and local ticket statuses. See [Triage labels](docs/agents/triage-labels.md).

### Domain docs

Use the single-context glossary and ADRs when exploring the domain. See [Domain docs](docs/agents/domain.md).
