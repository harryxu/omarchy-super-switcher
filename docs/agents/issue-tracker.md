# Issue tracker

Use GitHub Issues in `harryxu/omarchy-super-switcher` by default. Use local Markdown under `.scratch/` when the user asks to keep the work local or supplies a local ticket path. Keep follow-up work in the same tracker unless the user requests a transfer.

## GitHub Issues

- Create with `gh issue create -R harryxu/omarchy-super-switcher --title <title> --body-file <file>`.
- Read a ticket with `gh issue view <number> -R harryxu/omarchy-super-switcher --json number,title,body,labels,comments`. List tickets with `gh issue list -R harryxu/omarchy-super-switcher` and the relevant state and label filters.
- Comment with `gh issue comment <number> --body-file <file>`. Use `gh issue edit` to update labels and `gh issue close` to close a ticket after posting the resolution.
- Link implementation tickets with GitHub sub-issues and dependencies. If those features are unavailable, record parent and blocker references in the issue body. A ticket is unblocked when every blocker is closed.

**PRs as a request surface: no.**

## Local Markdown

- Store the spec in `.scratch/<feature-slug>/spec.md` and implementation tickets in `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01`.
- Read and update the referenced file directly. Record triage in a `Status:` line near the top using the [triage vocabulary](triage-labels.md), and append discussion under `## Comments`.
- Record dependencies with `Blocked by: NN, NN`. A ticket is unblocked when every listed ticket is resolved.

When a skill asks to publish to the issue tracker, create a ticket in the selected tracker. When it asks to fetch a ticket, use the tracker matching the issue reference or local path.
