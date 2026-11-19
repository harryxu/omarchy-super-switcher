# 无实际变化的窗口更新可能让图标短暂消失

Status: needs-triage
Scope: 主分支待核实

PR 报告 Hyprland 的窗口更新可能产生相同的应用列表，现有 `refreshApps()` 仍重新赋值 `panel.apps`。重新创建列表项时，图标可能空白一帧。

## 验证要点

在面板打开时制造应用列表内容相同的更新，核对列表项是否重建。覆盖应用顺序、窗口归属以及 `A` 范围实际变化时的刷新。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/03b439a202bcd96bc82748db056cc987eb6580a5)
