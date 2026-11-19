# 无实际变化的窗口更新可能让图标短暂消失

State: closed
Scope: 当前环境无需修复

PR 报告 Hyprland 的窗口更新可能产生相同的应用列表，现有 `refreshApps()` 仍重新赋值 `panel.apps`。重新创建列表项时，图标可能空白一帧。

## 验证结果

在 Qt 6.12 离屏测试和本机 Wayland 隔离面板中，打开应用列表后用当前 `refreshApps()` 各重复十次等内容更新。两组测试都观察到十次 `appsChanged`、零次 `ListView.modelChanged` 和零个新建列表项。原选中项和对象身份保持不变。Wayland 测试使用已安装的 `SwitcherPanel` 和 `SwitcherIcon`。

`A` 范围变化能正确更新应用的窗口列表。应用顺序和同一应用的窗口顺序确实变化时，列表会更新，原选中应用仍按 ID 保持选中。Qt 的 `QQuickItemView::setModel` 在转换 JS 值后会比较模型内容，相等时直接返回。Qt 6.10 源码也有这项检查。当前证据不足以支持增加一套项目级列表比较逻辑，本次未改运行代码。

[Qt 6.10 列表模型实现](https://github.com/qt/qtdeclarative/blob/6.10/src/quick/items/qquickitemview.cpp#L148-L164)

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/03b439a202bcd96bc82748db056cc987eb6580a5)
