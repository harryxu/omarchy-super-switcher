# PR #1 问题索引

以 PR 的七个提交、说明和评审为来源。主分支待核实的条目记录作者报告或代码线索。标为 PR 实现的条目记录后续移植时需验证的回归。

此 PR 的后续修复涉及代码改动时，按项目部署流程更新本机插件，并验证运行中的插件和相关快捷键。

[PR #1](https://github.com/harryxu/omarchy-super-switcher/pull/1) · [评审](https://github.com/harryxu/omarchy-super-switcher/pull/1#issuecomment-6900658919)

| 编号 | 问题 | 范围 |
| --- | --- | --- |
| 02 | [快速连按 Super+Tab 可能重复选择同一应用](issues/02-rapid-app-focus.md) | 已部署并复测 |
| 03 | [快速连按 Super+grave 可能重复选择同一窗口](issues/03-rapid-window-focus.md) | 已部署并复测 |
| 04 | [Shell 重启后应用顺序可能偏离最近使用顺序](issues/04-focus-history-after-restart.md) | 已部署并复测 |
| 05 | [面板首屏可能没有预览帧](issues/05-thumbnail-first-frame.md) | 已部署并复测 |
| 06 | [应用图标首帧可能跳变尺寸](issues/06-icon-size-pop.md) | 已部署并复测 |
| 07 | [无实际变化的窗口更新可能让图标短暂消失](issues/07-redundant-app-row-rebuild.md) | 当前环境无需修复 |
| 08 | [刚过长按阈值松键可能让面板闪现](issues/08-short-hold-panel-flash.md) | 已部署并复测 |
| 10 | [PR 的应用面板会额外等待预览兜底定时器](issues/10-app-reveal-fallback-delay.md) | 现有实现已覆盖 |
| 11 | [PR 的快点路径会提前创建预览项](issues/11-preview-starts-on-quick-tap.md) | 现有实现已覆盖 |
| 12 | [PR 的待确认焦点可能在三连按中重复使用](issues/12-stale-in-flight-focus.md) | 现有实现已覆盖 |
| 13 | [PR 在面板映射前抓图可能缓存错误图标边界](issues/13-icon-geometry-before-map.md) | PR 实现 |
