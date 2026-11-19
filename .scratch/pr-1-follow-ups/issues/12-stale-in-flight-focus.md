# PR 的待确认焦点可能在三连按中重复使用

Status: needs-triage
Scope: PR #1 的实现

PR 的第二次请求若指向 Hyprland 仍报告为 active 的窗口，会保留第一次的 `inFlightAddress`。第三次可能继续按过期目标计算，得到 `B、A、A`。

## 验证要点

用三个连续请求复现 `A` 的焦点报告滞后，确认最新目标应取代旧目标。另覆盖报告顺序变化和目标窗口在请求途中关闭。关联 #02、#03。

[PR 评审](https://github.com/harryxu/omarchy-super-switcher/pull/1#issuecomment-6900658919)
