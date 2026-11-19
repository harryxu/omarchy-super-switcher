# Shell 重启后应用顺序可能偏离最近使用顺序

State: closed
Scope: 已部署并复测

重启清空插件内存中的焦点历史。PR 报告未记录的窗口仍按合成器列表顺序排列，并提出用 Hyprland 的 `focusHistoryID` 作为回退。

## 验证与处理结果

模型测试复现了重启后应用顺序和应用内目标窗口不符合最近使用顺序的问题。应用排序现在优先采用插件已观察的焦点顺序，再用 Hyprland 的 `focusHistoryID` 排列其余窗口。缺失或无效的排名保留原有相对顺序。

首次实机测试还发现需要主动请求窗口快照。即使快照已就绪，`activeToplevel` 也可能尚未建立，导致首次快点选中已聚焦的窗口。插件现在启动时请求一次窗口快照，并在收到首个有效焦点事件前用快照中的第 0 名补齐当前窗口。

已部署到本机并重启 Omarchy Shell。使用四个临时窗口建立 `C → B-recent → A → B-old` 的最近使用顺序。重启后的前两次 `Super+Tab` IPC 快点按预期完成了 `C → B-recent → C`。两个 IPC 入口和 12 条快捷键绑定 已验证，测试窗口已关闭，原焦点已恢复。

[来源提交](https://github.com/harryxu/omarchy-super-switcher/commit/eda33c3e65a09523a253b8de17518113dce551f7)
