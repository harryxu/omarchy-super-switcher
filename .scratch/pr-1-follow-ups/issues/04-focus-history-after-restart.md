# Shell 重启后应用顺序可能偏离最近使用顺序

Status: needs-triage
Scope: 主分支待核实

重启清空插件内存中的焦点历史。PR 报告未记录的窗口仍按合成器列表顺序排列，并提出用 Hyprland 的 `focusHistoryID` 作为回退。

## 验证要点

在已知焦点顺序下重启 Shell，检查首次打开时的应用顺序。覆盖已记录的窗口以及缺失、无效的 `focusHistoryID`。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/eda33c3e65a09523a253b8de17518113dce551f7)
